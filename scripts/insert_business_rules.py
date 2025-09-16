from pathlib import Path
import re
import sys
import argparse

CSV = Path('.doc_issues_counts.csv')

BUSINESS_SECTION = (
    '/// **Business Rules:**\n'
    '/// - Add the main business rules or invariants enforced by this class.\n'
)

DOC_TEMPLATE_CLASS = (
    '/// {name}\n'
    '///\n'
    '/// **Business Rules:**\n'
    '/// - Add the main business rules or invariants enforced by this class.\n'
    '///\n'
)


def parse_args():
    p = argparse.ArgumentParser(description='Insert Business Rules and optional method doc stubs')
    p.add_argument('batch_size', nargs='?', type=int, default=30)
    p.add_argument('offset', nargs='?', type=int, default=0)
    p.add_argument('-m', '--method-stubs', action='store_true', help='Also insert conservative @param/@return stubs for methods')
    p.add_argument('--dry-run', action='store_true', help='Do not write files, only show what would change')
    return p.parse_args()


def safe_param_names(param_str):
    """Return a conservative list of parameter names from a param string.
    Skip complex parameters (function-typed, generics with < >)."""
    if not param_str.strip():
        return []
    parts = []
    depth = 0
    cur = ''
    for ch in param_str:
        if ch == '<':
            depth += 1
        elif ch == '>':
            depth = max(0, depth - 1)
        if ch == ',' and depth == 0:
            parts.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())

    names = []
    for p in parts:
        # skip function-typed params or very complex types
        if '(' in p or 'Function' in p or '=>' in p or '<' in p:
            continue
        # remove default values
        p = p.split('=')[0].strip()
        toks = p.split()
        if not toks:
            continue
        # last token is likely the name (could have leading { or [ for optional)
        name = toks[-1].lstrip('{[').rstrip(']').rstrip('}').strip()
        # ignore parameters that look like types or empty
        if not re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', name):
            continue
        names.append(name)
    return names


def insert_method_stubs_into_text(text):
    """Conservatively insert /// @param and /// Returns: lines for simple methods.
    Returns (new_text, changed_flag)."""
    changed = False

    # Regex to find simple method/function signatures (conservative):
    # matches return_type name(param list) [async] { or =>
    method_pattern = re.compile(r"(^\s*(?:[A-Za-z0-9_<>,\s\?]+)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*(?:async\s*)?(?:\{|=>))", re.MULTILINE)

    def method_repl(match):
        nonlocal changed
        full_sig = match.group(0)
        name = match.group(2)
        params = match.group(3)

        # find preceding docblock (/// lines) directly above the signature
        start = match.start()
        before = text[:start]
        last_double_newline = before.rfind('\n\n')
        # take up to 200 chars before the signature for safety
        scan_start = max(0, start - 800)
        segment = text[scan_start:start]
        # capture trailing /// lines if any
        m = re.search(r"((?:\s*///.*\n)*)\s*$", segment)
        docblock = m.group(1) if m else ''

        param_names = safe_param_names(params)
        # if no useful params and return is void-like, skip
        # Determine return type from the signature by a quick heuristic
        ret_match = re.match(r"^\s*([A-Za-z0-9_<>,\s\?]+)\s+" + re.escape(name), full_sig)
        return_type = ret_match.group(1).strip() if ret_match else ''
        is_void = return_type in ('void', '')

        # If no docblock, create one
        if docblock.strip() == '':
            lines = []
            lines.append('/// ' + name)
            lines.append('///')
            for pn in param_names:
                lines.append(f'/// @param {pn} ')  # conservative placeholder
            if not is_void:
                lines.append('/// Returns: ')
            newblock = '\n'.join(lines) + '\n'
            changed = True
            return newblock + full_sig

        # There is a docblock: check whether param names are documented
        doc_lower = docblock.lower()
        need_inject = False
        injection = []
        for pn in param_names:
            if pn.lower() not in doc_lower:
                injection.append(f'/// @param {pn} ')
                need_inject = True

        if (not is_void) and ('returns' not in doc_lower and '@return' not in doc_lower and 'return' not in doc_lower):
            injection.append('/// Returns: ')
            need_inject = True

        if not need_inject:
            return full_sig

        # insert injection lines after the first summary line of the docblock
        lines = docblock.splitlines()
        insert_at = 1
        for i, ln in enumerate(lines):
            if ln.strip().startswith('///'):
                insert_at = i + 1
                break
        # format injection lines (they already start with /// )
        lines[insert_at:insert_at] = injection
        newblock = '\n'.join(lines) + '\n'
        changed = True
        return newblock + full_sig

    # perform substitution; limit the number of substitutions to avoid accidental mass edits
    new_text, nsub = method_pattern.subn(method_repl, text)
    return new_text, changed


def main():
    if not CSV.exists():
        print('CSV with issue counts not found:', CSV)
        raise SystemExit(1)

    args = parse_args()
    BATCH_SIZE = args.batch_size
    OFFSET = args.offset
    METHOD_STUBS = args.method_stubs
    DRY_RUN = args.dry_run

    lines = CSV.read_text(encoding='utf-8').splitlines()
    entries = []
    for l in lines:
        if not l.strip():
            continue
        parts = l.split(',')
        path = parts[0].strip()
        try:
            issues = int(parts[1])
        except:
            issues = 0
        if issues > 0:
            entries.append((path, issues))

    selected = entries[OFFSET:OFFSET + BATCH_SIZE]
    print(f'Processing {len(selected)} files (batch size {BATCH_SIZE}, offset {OFFSET})')

    patched = []
    for path, issues in selected:
        p = Path(path)
        if not p.exists():
            print('Missing file:', path)
            continue
        text = p.read_text(encoding='utf-8')
        original = text

        # class-level insertion (existing behavior)
        changed_flags = {'changed': False}
        pattern = re.compile(r"((?:\s*///.*\n)*)\s*(class\s+[A-Z][A-Za-z0-9_<>]*)", re.MULTILINE)

        def repl(match):
            docblock = match.group(1)
            class_decl = match.group(2)
            if docblock.strip() == '':
                mname = re.search(r'class\s+([A-Z][A-Za-z0-9_]*)', class_decl)
                name = mname.group(1) if mname else 'Class'
                newblock = DOC_TEMPLATE_CLASS.format(name=name)
                changed_flags['changed'] = True
                return newblock + class_decl
            else:
                if 'Business Rules' in docblock or 'Business rules' in docblock:
                    return docblock + class_decl
                lines = docblock.splitlines()
                for i, ln in enumerate(lines):
                    if ln.strip().startswith('///'):
                        insert_at = i + 1
                        section_lines = BUSINESS_SECTION.strip('\n').split('\n')
                        lines[insert_at:insert_at] = section_lines
                        break
                newblock = '\n'.join(lines) + '\n'
                changed_flags['changed'] = True
                return newblock + class_decl

        new_text = pattern.sub(repl, text)

        # optional method-level stubs
        if METHOD_STUBS:
            new_text, method_changed = insert_method_stubs_into_text(new_text)
            if method_changed:
                changed_flags['changed'] = True

        if changed_flags['changed'] and new_text != original:
            print('Patched', path)
            if DRY_RUN:
                # show a short diff-ish summary
                import difflib
                diff = difflib.unified_diff(original.splitlines(), new_text.splitlines(), fromfile=path, tofile=path + '.new', lineterm='')
                for i, line in enumerate(diff):
                    if i > 200:
                        print('...diff truncated...')
                        break
                    print(line)
            else:
                bak = p.with_suffix(p.suffix + '.bak')
                if not bak.exists():
                    bak.write_text(original, encoding='utf-8')
                p.write_text(new_text, encoding='utf-8')
            patched.append(path)

    print('\nPatched files:', len(patched))
    for f in patched:
        print(' -', f)


if __name__ == '__main__':
    main()
