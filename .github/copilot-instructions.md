## Quick guide for coding agents — Fix It
```instructions
## Quick guide for coding agents — Fix It

Keep this short and concrete. Reference only discoverable patterns and exact files.

### 1) Big picture
- Architecture: Clean Architecture (presentation → domain → data → external). UI uses BLoC (`flutter_bloc`) and DI uses GetIt (see `lib/core/di/injection_container.dart`).
- Entry points: `lib/main.dart` (app bootstrap) and `lib/core/di/injection_container.dart` (dependency registration via `sl`).

### 2) Quick checklist for making changes
- Feature layout: `features/<feature>/{domain,data,presentation}`. Typical order: models → datasources → repository_impl → usecases → bloc → pages/widgets. Example features: `features/auth`, `features/providers`.
- Register implementations in `lib/core/di/injection_container.dart`. Pattern: externals (SharedPreferences, Dio, Firebase) → datasources → repositories → usecases → blocs. Search for `sl.register` / `sl.get<T>()`.

### 3) DI & runtime patterns (concrete)
- DI uses GetIt. Prefer `registerLazySingleton` for services/datasources and `registerFactory` for blocs.
- External services are initialized in `init()` inside `injection_container.dart`. Tests assume the registration order — avoid reordering without updating tests.

### 4) Network & services (concrete files)
- HTTP client: `lib/core/network/api_client.dart` (Dio). Generated code lives at `lib/core/network/api_client.g.dart` — regenerate if you change API annotations.
- Network gating: `lib/core/network/network_info.dart` — repositories check `isConnected` before remote calls.
- Major services: `lib/core/services/auth_service.dart`, `lib/core/services/payment_service.dart`, `lib/core/services/location_service.dart`; Firebase config is in `firebase_options.dart`.

### 5) Tests, commands & CI (exact)
- Static analysis: `flutter analyze`.
- Run tests: `flutter test` or a targeted file `flutter test test/path/to/file.dart`.
- CI/test wrapper: `dart test/run_tests.dart` (CI uses this wrapper; run it locally to mirror CI).
- Coverage: `flutter test --coverage` then `genhtml coverage/lcov.info --output-dir=coverage/html`.

### 6) Testing conventions & gotchas (concrete)
- Mocking: project uses `mocktail`. When using `any()` for non-primitive types call `registerFallbackValue()` with a `Fake` in test setup. See tests under `test/features/...` for patterns.
- Network stubs: stub `NetworkInfo.isConnected` to return `Future<bool>` (e.g., `thenAnswer((_) async => true)`).
- BLoC tests: states extend `Equatable` — tests often assert precise state sequences; use `isA<...>()` when sequences are fragile.
- Widget scope gotcha: avoid `context.read<T>()` in `initState()` if provider/bloc is created higher in the tree; use `didChangeDependencies()` or a builder.
- Cache keys: prefix cache keys with the feature name. Example: `features/providers/data/datasources/provider_local_data_source.dart`.

### 7) Concrete examples & shortcuts
- DI: `lib/core/di/injection_container.dart` (look for `registerLazySingleton` / `registerFactory`).
- Feature example: `lib/features/home/presentation/pages/main_dashboard.dart` (uses `MultiBlocProvider`).
- Remote datasource example: `features/auth/data/datasources/auth_firebase_data_source.dart`.

### 8) PR tips for agents

If any section is unclear or you want a template (DI registration snippet, feature scaffold, or test stubs), tell me which to expand.


### 9) Code generation & localization (exact commands)
- Regenerate codegen (retrofit/json_serializable/freezed/etc) after changing annotated models or API interfaces:

```powershell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

- Watch mode when iterating locally:

```powershell
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

- Regenerate localization if ARB or gen-l10n config changes:

```powershell
flutter gen-l10n
```

- Integration tests (run locally against attached device/emulator):

```powershell
flutter test integration_test
```

- Formatting / linting quick commands:

```powershell
dart format .
flutter analyze
```

- Files that are generated (do not manually edit): `**/*.g.dart`, `**/*.freezed.dart`, `**/*.mocks.dart`, `lib/core/network/api_client.g.dart`, generated `lib/l10n/*` files. If you change annotations, run build_runner and commit regenerated files.

- Generator dev-dependencies to know: `build_runner`, `retrofit_generator`, `json_serializable` (see `pubspec.yaml`). When editing API annotations or model annotations, run build_runner locally to match CI.

- CI note: CI runs a codegen step (see `.github/workflows/ci.yml`) — mirror CI by running the same build_runner command locally before opening PRs. Commit regenerated `*.g.dart` / generated l10n files to avoid CI-only diffs.

- Firebase note: `lib/firebase_options.dart` contains placeholders in some branches — follow `FIREBASE_SETUP.md` / `FIREBASE_SETUP_DETAILED.md` before running Firebase-dependent flows.

```
