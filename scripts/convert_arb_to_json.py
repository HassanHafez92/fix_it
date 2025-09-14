import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
l10n = root / 'lib' / 'l10n'
out_dir = root / 'assets' / 'translations'
out_dir.mkdir(parents=True, exist_ok=True)

for lang in ['en', 'ar']:
    arb_file = l10n / f'app_{lang}.arb'
    if not arb_file.exists():
        print(f'Missing {arb_file}')
        continue
    with open(arb_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    out = {}
    for k, v in data.items():
        if k.startswith('@'):
            continue
        if k == '@@locale':
            continue
        if k in out:
            # keep first occurrence
            continue
        out[k] = v
    # sort keys
    out_sorted = {k: out[k] for k in sorted(out.keys())} # type: ignore
    out_file = out_dir / f'{lang}.json'
    with open(out_file, 'w', encoding='utf-8') as f:
        json.dump(out_sorted, f, ensure_ascii=False, indent=2)
    print(f'Wrote {out_file} ({len(out_sorted)} keys)') # type: ignore
