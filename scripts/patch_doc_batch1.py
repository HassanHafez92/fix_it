from pathlib import Path
import re
files = [
 'lib/core/bloc/theme_cubit.dart',
 'lib/core/routes/app_routes.dart',
 'lib/core/services/localization_service.dart',
 'lib/core/utils/image_cache_manager.dart',
 'lib/features/auth/data/models/user_model.dart',
 'lib/features/auth/domain/entities/user_entity.dart'
]
for p in files:
    path = Path(p)
    if not path.exists():
        print('Missing', p)
        continue
    text = path.read_text(encoding='utf-8')
    if text.strip().startswith('///'):
        print('Already documented:', p)
        continue
    m = re.search(r'class\s+([A-Z][A-Za-z0-9_]*)', text)
    name = m.group(1) if m else Path(p).stem
    stub = f'/// {name}\n///\n/// Business Rules:\n/// - Add the main business rules or invariants enforced by this class.\n\n'
    new = stub + text
    # backup
    bak = path.with_suffix(path.suffix + '.bak')
    if not bak.exists():
        bak.write_text(text, encoding='utf-8')
    path.write_text(new, encoding='utf-8')
    print('Patched', p)
