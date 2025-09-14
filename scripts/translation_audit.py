#!/usr/bin/env python3
import re
import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
lib_dir = root / 'lib'
translations_dir = root / 'assets' / 'translations'

pattern = re.compile(r"tr\(\s*['\"]([^'\"]+)['\"]\s*\)")

keys_found = set()
files_scanned = 0
for p in lib_dir.rglob('*.dart'):
    files_scanned += 1
    try:
        text = p.read_text(encoding='utf-8')
    except Exception:
        continue
    for m in pattern.finditer(text):
        keys_found.add(m.group(1))

print(f"Scanned {files_scanned} Dart files; found {len(keys_found)} unique tr() keys.")

languages = {}
for f in translations_dir.glob('*.json'):
    lang = f.stem
    try:
        data = json.loads(f.read_text(encoding='utf-8'))
    except Exception as e:
        print(f"Failed to parse {f}: {e}")
        continue
    # JSON may be nested; flatten keys by joining with '.' if nested
    def flatten(d, prefix=''):
        out = {}
        if isinstance(d, dict):
            for k,v in d.items():
                new_key = f"{prefix}.{k}" if prefix else k
                if isinstance(v, dict):
                    out.update(flatten(v, new_key))
                else:
                    out[new_key] = v
        else:
            pass
        return out
    flat = flatten(data)
    languages[lang] = set(flat.keys())
    print(f"Loaded {len(flat)} keys for language '{lang}' from {f.name}.")

if not languages:
    print("No translation files found under assets/translations. Exiting.")
    sys.exit(2)

# Report missing keys per language
missing = {}
for lang, keys in languages.items():
    missing_keys = sorted([k for k in keys_found if k not in keys])
    missing[lang] = missing_keys
    print(f"\nLanguage '{lang}' missing {len(missing_keys)} keys:")
    for k in missing_keys[:200]:
        print(f"  {k}")
    if len(missing_keys) > 200:
        print(f"  ... and {len(missing_keys)-200} more")

# Unused keys in translations
for lang, keys in languages.items():
    unused = sorted([k for k in keys if k not in keys_found])
    print(f"\nLanguage '{lang}' has {len(unused)} unused translation keys (present but not used):")
    for k in unused[:200]:
        print(f"  {k}")
    if len(unused) > 200:
        print(f"  ... and {len(unused)-200} more")

# Exit code: 0 if no missing keys in any language, else 3
any_missing = any(len(v)>0 for v in missing.values())
print('\nSummary:')
print(f"  total tr() keys found: {len(keys_found)}")
for lang,v in languages.items():
    print(f"  {lang}: {len(v)} translation keys")
print(f"  any missing: {any_missing}")

sys.exit(0 if not any_missing else 3)
