
import 'dart:io';

/// Configuration class for test settings
class TestConfig {
  // Target coverage percentage for unit tests
  static const double unitTestCoverageTarget = 0.80; // 80%

  // Target coverage percentage for widget tests
  static const double widgetTestCoverageTarget = 0.75; // 75%

  // Target coverage percentage for integration tests
  static const double integrationTestCoverageTarget = 0.70; // 70%

  // List of files to exclude from coverage analysis
  static const List<String> coverageExcludes = [
    'lib/generate.dart',
    'lib/main.dart',
  ];

  // List of directories to prioritize for testing
  static const List<String> priorityTestDirectories = [
    'lib/features/auth',
    'lib/features/booking',
    'lib/features/payment',
  ];

  // Test environment configuration
  static bool get isCi => Platform.environment['CI'] == 'true';

  // Firebase test lab configuration
  static const bool enableFirebaseTestLab = true;

  // Test timeout settings (in seconds)
  static const int widgetTestTimeout = 30;
  static const int integrationTestTimeout = 120;
  static const int endToEndTestTimeout = 300;

  // Device configurations for integration testing
  static const List<String> integrationTestDevices = [
    'Pixel_4_API_30',
    'Nexus_5_API_23',
  ];

  // Helper method to check if a file should be excluded from coverage
  static bool shouldExcludeFromCoverage(String filePath) {
    return coverageExcludes.any((exclude) => filePath.contains(exclude));
  }

  // Helper method to check if a directory is a priority for testing
  static bool isPriorityTestDirectory(String directoryPath) {
    return priorityTestDirectories.any((priority) => directoryPath.contains(priority));
  }
}
