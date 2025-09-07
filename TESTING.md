
# Testing Guide for FixIt App

## Overview

This document outlines the testing strategy and implementation for the FixIt application. We follow a comprehensive testing approach that includes unit tests, widget tests, integration tests, and end-to-end tests to ensure the quality and reliability of our application.

## Testing Structure

Our tests are organized in the following structure:

```test/
├── features/          # Feature-specific tests
│   ├── auth/          # Authentication feature tests
│   ├── booking/       # Booking feature tests
│   ├── payment/       # Payment feature tests
│   └── ...
├── integration/       # Integration tests
├── run_tests.dart     # Test runner script
└── test_config.dart   # Test configuration
```

## Types of Tests

### 1. Unit Tests

Unit tests test individual units of code in isolation, such as functions, methods, and classes. We use the `test` package for writing unit tests.

**Key Components:**

- Domain layer tests (use cases, entities)
- Data layer tests (repositories, data sources)
- BLoC tests (using the `bloc_test` package)

**Example:**

```dart
test('should return UserEntity when sign in is successful', () async {
  // arrange
  when(() => mockSignInUseCase(any))
      .thenAnswer((_) async => const Right(tUser));

  // act
  final result = await signInUseCase(const SignInParams(
    email: tEmail,
    password: tPassword,
  ));

  // assert
  expect(result, const Right(tUser));
});
```

### 2. Widget Tests

Widget tests test a single widget and its interaction with other widgets. We use the `flutter_test` package for writing widget tests.

**Key Components:**

- UI component tests
- Page widget tests
- Custom widget tests

**Example:**

```dart
testWidgets('displays email and password fields', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: SignInScreen(),
    ),
  );

  expect(find.byKey(const Key('email_field')), findsOneWidget);
  expect(find.byKey(const Key('password_field')), findsOneWidget);
});
```

### 3. Integration Tests

Integration tests verify that different parts of the application work together correctly. We use the `integration_test` package for writing integration tests.

**Key Components:**

- Firebase operations tests
- API integration tests
- Database operation tests

**Example:**

```dart
testWidgets('Firebase initialization test', (WidgetTester tester) async {
  // Build the app and trigger a frame.
  await tester.pumpWidget(const FixItApp());
  await tester.pumpAndSettle();

  // Verify that the app is loaded
  expect(find.byType(FixItApp), findsOneWidget);
});
```

### 4. End-to-End Tests

End-to-end tests simulate user interactions with the application to verify complete user flows. We use the `integration_test` package for writing end-to-end tests.

**Key Components:**

- Complete user journey tests
- Critical business flow tests
- Cross-functional feature tests

**Example:**

```dart
testWidgets('Complete booking flow', (WidgetTester tester) async {
  // Build the app and trigger a frame.
  await tester.pumpWidget(const FixItApp());
  await tester.pumpAndSettle();

  // Step 1: Login
  // ... test steps ...
});
```

## Running Tests

### Running All Tests

To run all tests, use the following command:

```bash
flutter test
```

### Running Specific Test Types

To run only unit tests:

```bash
flutter test test/features/
```

To run only widget tests:

```bash
flutter test test/features/
```

To run only integration tests:

```bash
flutter test test/integration/
```

### Running Tests with Coverage

To run tests with coverage reporting:

```bash
flutter test --coverage
```

This will generate a coverage report in the `coverage` directory. You can view the HTML report by running:

```bash
genhtml coverage/lcov.info --output-dir=coverage/html
```

Then open `coverage/html/index.html` in your browser.

### Using the Test Runner

We've created a test runner script that can be used to run tests with specific configurations:

```bash
dart test/run_tests.dart
```

This script will:

1. Run all test types
2. Generate coverage reports
3. Check if coverage meets targets
4. Generate HTML reports

## Test Coverage Goals

We aim for the following test coverage targets:

- Unit tests: 80%+ coverage
- Widget tests: 75%+ coverage
- Integration tests: 70%+ coverage

## Continuous Integration

We use GitHub Actions to run tests automatically on every push and pull request. The CI/CD pipeline includes:

1. Static analysis (`flutter analyze`)
2. Unit tests with coverage
3. Widget tests
4. Integration tests
5. End-to-end tests (on main branch)
6. Build artifacts (on main branch)

## Firebase Test Lab

For comprehensive testing on real devices, we use Firebase Test Lab. This allows us to run our tests on a variety of physical devices and configurations.

## Best Practices

1. **Arrange-Act-Assert Pattern**: Structure tests with clear arrangement of inputs, action to be tested, and assertion of results.

2. **Descriptive Test Names**: Use clear and descriptive test names that explain what is being tested.

3. **Mock External Dependencies**: Use mock objects to isolate the unit being tested.

4. **Test Edge Cases**: Include tests for edge cases, error conditions, and unexpected inputs.

5. **Keep Tests Simple**: Each test should focus on testing a single behavior or outcome.

6. **Regular Maintenance**: Update tests as the codebase evolves to ensure they remain relevant and accurate.

## Troubleshooting

### Common Issues

1. **Test Failures on CI**:
   - Ensure all dependencies are correctly specified in `pubspec.yaml`
   - Check for platform-specific code that may not run in the CI environment
   - Verify that all required environment variables are set

2. **Coverage Reports Not Generated**:
   - Make sure you're using the `--coverage` flag when running tests
   - Check that the coverage dependencies are installed

3. **Widget Test Timing Issues**:
   - Use `pumpAndSettle()` instead of `pump()` when waiting for animations to complete
   - Adjust test timeouts if needed

## Getting Help

If you encounter issues with tests or have questions about testing practices, please:

1. Check the Flutter testing documentation: <https://docs.flutter.dev/testing>
2. Consult the project's README and CONTRIBUTING files
3. Reach out to the development team through the project's communication channels
