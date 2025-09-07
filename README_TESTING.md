
# Testing in FixIt App

This section provides information about testing practices and how to run tests in the FixIt application.

## Running Tests

### Unit Tests
Run all unit tests:
```bash
flutter test
```

Run specific feature tests:
```bash
flutter test test/features/auth/
```

### Widget Tests
Run widget tests:
```bash
flutter test test/features/auth/pages/
```

### Integration Tests
Run integration tests:
```bash
flutter test test/integration/
```

### Running Tests with Coverage
Generate coverage reports:
```bash
flutter test --coverage
```

View HTML coverage report:
```bash
genhtml coverage/lcov.info --output-dir=coverage/html
```

### Using the Test Runner
Run tests using our custom test runner:
```bash
dart test/run_tests.dart
```

## Test Coverage Goals

We aim for the following test coverage targets:
- Unit tests: 80%+ coverage
- Widget tests: 75%+ coverage
- Integration tests: 70%+ coverage

## Continuous Integration

Tests are automatically run on every push and pull request through our GitHub Actions workflow. The CI pipeline includes:

1. Static analysis (`flutter analyze`)
2. Unit tests with coverage
3. Widget tests
4. Integration tests
5. End-to-end tests (on main branch)
6. Build artifacts (on main branch)

For more information on testing practices, see [TESTING.md](TESTING.md).
