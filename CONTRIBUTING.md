# Contributing to Fix It

Welcome to the Fix It project! We're excited that you're interested in contributing. This guide will help you get started and ensure that your contributions align with our project standards.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Project Structure](#project-structure)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Documentation Standards](#documentation-standards)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background, experience level, or identity.

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Publishing private information without permission
- Any conduct that would be inappropriate in a professional setting

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Flutter SDK 3.10.0+
- Dart SDK 3.0.0+
- Android Studio or VS Code with Flutter plugins
- Git for version control
- Firebase account for backend services

### Environment Setup

1. **Fork and Clone Repository**
   ```bash
   git clone https://github.com/your-username/fix_it.git
   cd fix_it
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Follow the [Firebase Setup Guide](FIREBASE_SETUP.md)
   - Configure your own Firebase project for development

4. **Run the App**
   ```bash
   flutter run
   ```

5. **Verify Setup**
   ```bash
   flutter doctor
   flutter test
   ```

## Development Workflow

### Branch Strategy

We use **Git Flow** with the following branch structure:

```
main                    # Production-ready code
├── develop            # Integration branch for features
├── feature/auth-ui    # Feature development
├── feature/booking    # Feature development
├── hotfix/payment-bug # Critical bug fixes
└── release/v1.2.0     # Release preparation
```

### Branch Naming Convention

- **Features**: `feature/description-of-feature`
- **Bug Fixes**: `fix/description-of-bug`
- **Hotfixes**: `hotfix/critical-issue`
- **Releases**: `release/version-number`

### Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(auth): add Google sign-in integration
fix(booking): resolve date picker timezone issue
docs(readme): update installation instructions
test(auth): add unit tests for sign-in use case
```

## Coding Standards

### Dart/Flutter Style Guide

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart) with these additions:

#### File Organization

```dart
// 1. Dart/Flutter imports
import 'dart:async';
import 'package:flutter/material.dart';

// 2. Package imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Relative imports
import '../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
```

#### Class Documentation

```dart
/// Brief description of the class purpose.
/// 
/// Longer description explaining the class functionality,
/// usage patterns, and important considerations.
/// 
/// Example:
/// ```dart
/// final authBloc = AuthBloc(signInUseCase);
/// authBloc.add(SignInRequested(email, password));
/// ```
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Implementation
}
```

#### Method Documentation

```dart
/// Authenticates user with email and password.
/// 
/// Returns [UserEntity] on successful authentication or
/// throws [AuthenticationFailure] on failure.
/// 
/// Parameters:
/// - [email]: User's email address
/// - [password]: User's password
Future<Either<Failure, UserEntity>> signIn({
  required String email,
  required String password,
}) async {
  // Implementation
}
```

### Architecture Guidelines

#### Clean Architecture Layers

```
presentation/
├── bloc/          # State management
├── pages/         # Screen widgets
└── widgets/       # Reusable UI components

domain/
├── entities/      # Business objects
├── repositories/  # Data access interfaces
└── usecases/      # Business logic

data/
├── datasources/   # API and local data sources
├── models/        # Data transfer objects
└── repositories/  # Repository implementations
```

#### BLoC Pattern

```dart
// Event classes
abstract class AuthEvent extends Equatable {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// State classes
abstract class AuthState extends Equatable {}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}
```

#### Dependency Injection

```dart
// Register dependencies in injection_container.dart
void init() {
  // BLoCs
  sl.registerFactory(() => AuthBloc(
    signInUseCase: sl(),
    signUpUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseDataSource: sl(),
      localDataSource: sl(),
    ),
  );
}
```

### Code Quality Standards

#### Required Checks

- [ ] Code follows Dart style guide
- [ ] All public APIs are documented
- [ ] Unit tests cover new functionality
- [ ] No lint warnings or errors
- [ ] Performance considerations addressed

#### Static Analysis

```bash
# Run before committing
flutter analyze
dart format --set-exit-if-changed .
```

## Project Structure

### Feature-Based Organization

```
lib/
├── core/                    # Shared infrastructure
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── network/            # API configuration
│   ├── routes/             # Navigation
│   ├── services/           # Core services
│   ├── theme/              # UI theming
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── auth/               # Authentication
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── booking/            # Booking management
│   ├── chat/               # Messaging
│   ├── home/               # Home screen
│   ├── payment/            # Payment processing
│   ├── profile/            # User profile
│   ├── providers/          # Service providers
│   └── services/           # Service catalog
└── main.dart               # App entry point
```

### Adding New Features

1. **Create Feature Directory**
   ```
   features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       ├── pages/
       └── widgets/
   ```

2. **Register Dependencies**
   ```dart
   // In injection_container.dart
   void _initNewFeature() {
     // Register all dependencies
   }
   ```

3. **Add Routes**
   ```dart
   // In app_routes.dart
   case '/new-feature':
     return MaterialPageRoute(
       builder: (_) => NewFeaturePage(),
     );
   ```

## Testing Guidelines

### Test Structure

```
test/
├── core/
│   ├── error/
│   └── usecases/
├── features/
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── helpers/
    ├── test_helper.dart
    └── fixtures/
```

### Unit Tests

```dart
group('SignInUseCase', () {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  test('should return UserEntity when credentials are valid', () async {
    // arrange
    const tUser = UserEntity(id: '1', email: 'test@example.com');
    when(() => mockRepository.signIn(any(), any()))
        .thenAnswer((_) async => const Right(tUser));

    // act
    final result = await useCase(const SignInParams(
      email: 'test@example.com',
      password: 'password123',
    ));

    // assert
    expect(result, const Right(tUser));
    verify(() => mockRepository.signIn('test@example.com', 'password123'));
  });
});
```

### Widget Tests

```dart
testWidgets('should display sign in form', (WidgetTester tester) async {
  // arrange
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => mockAuthBloc,
        child: const SignInPage(),
      ),
    ),
  );

  // assert
  expect(find.byType(TextFormField), findsNWidgets(2));
  expect(find.text('Email'), findsOneWidget);
  expect(find.text('Password'), findsOneWidget);
  expect(find.byType(ElevatedButton), findsOneWidget);
});
```

### Test Coverage

Maintain minimum test coverage:
- **Unit Tests**: 80% coverage
- **Widget Tests**: Major UI components
- **Integration Tests**: Critical user flows

```bash
# Run tests with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Pull Request Process

### Before Creating PR

1. **Sync with Latest Changes**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout your-feature-branch
   git rebase develop
   ```

2. **Run Quality Checks**
   ```bash
   flutter analyze
   dart format .
   flutter test
   ```

3. **Update Documentation**
   - Update relevant documentation
   - Add/update code comments
   - Update CHANGELOG.md if needed

### PR Template

```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests pass locally
- [ ] No new warnings/errors

## Screenshots (if applicable)
Add screenshots of UI changes.
```

### Review Process

1. **Automated Checks**
   - CI/CD pipeline runs
   - Code quality analysis
   - Test execution

2. **Manual Review**
   - Code review by team member
   - Architecture compliance check
   - Performance considerations

3. **Approval and Merge**
   - Required approvals obtained
   - Merge to develop branch
   - Delete feature branch

## Issue Reporting

### Bug Reports

Use the bug report template:

```markdown
**Bug Description**
Clear description of the bug.

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen.

**Actual Behavior**
What actually happens.

**Environment**
- Flutter version:
- Device:
- OS version:
- App version:

**Screenshots**
Add screenshots if applicable.

**Additional Context**
Any other relevant information.
```

### Feature Requests

```markdown
**Feature Description**
Clear description of the feature.

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should this be implemented?

**Alternatives Considered**
Other approaches considered.

**Additional Context**
Any other relevant information.
```

## Documentation Standards

### README Files

Each feature should have a README.md explaining:
- Purpose and functionality
- Setup requirements
- Usage examples
- API documentation

### Code Comments

```dart
/// Class-level documentation
class ServiceRepository {
  /// Method documentation
  /// 
  /// Parameters:
  /// - [id]: Service identifier
  /// 
  /// Returns:
  /// Service entity or failure
  Future<Either<Failure, Service>> getService(String id) async {
    // Implementation comments for complex logic
    final cachedService = await _getCachedService(id);

    if (cachedService != null) {
      return Right(cachedService);
    }

    // Fallback to remote data source
    return await _getRemoteService(id);
  }
}
```

### API Documentation

Document all public APIs with:
- Purpose and usage
- Parameters and return types
- Error conditions
- Examples

## Getting Help

- **Discord/Slack**: Join our development chat
- **GitHub Discussions**: Ask questions and share ideas
- **Issues**: Report bugs and request features
- **Documentation**: Check existing docs first

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project README

Thank you for contributing to Fix It! 🎉