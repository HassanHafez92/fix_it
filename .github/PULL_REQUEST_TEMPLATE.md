## Summary

<!-- Short description of the change. Include motivation and context. -->

## Type of change

- [ ] feat: new feature
- [ ] fix: bug fix
- [ ] docs: documentation only changes
- [ ] style: formatting, missing semi-colons, etc
- [ ] refactor: code change that neither fixes a bug nor adds a feature
- [ ] test: adding or fixing tests
- [ ] chore: build process or auxiliary tool changes

## Related issue
<!-- Link to an existing issue, or leave blank if none. -->

## How to test / reproduce

1. Describe the steps to reproduce or test the change locally.
2. Include exact commands, device/emulator targets, or test names.

## Checklist

- [ ] The code builds and runs (e.g., `flutter analyze`, `flutter test`).
- [ ] New and existing unit/widget/integration tests pass.
- [ ] Lint warnings addressed (run `flutter analyze`).
- [ ] I added/updated documentation where relevant (README, comments, docs/).
- [ ] I updated DI registration in `lib/core/di/injection_container.dart` when adding new services/blocs.
- [ ] If codegen was required, I ran `flutter packages pub run build_runner build --delete-conflicting-outputs` and included any generated files if our project policy requires them.

## Migration / Release notes (optional)

- Describe any database migrations, breaking changes, or manual steps required for release.

## Screenshots or recordings (optional)

- Attach screenshots, GIFs, or short screen recordings to help reviewers.

---

If this PR touches sensitive areas (auth, payments, security rules), add a note for a security review and/or QA.
