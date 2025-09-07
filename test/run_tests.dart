
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'test_config.dart';

void main() async {
  // Enable coverage collection
  // Note: TestConfig is a utility class with static methods, not an instance

  // Define test groups
  final unitTests = [
    'test/features',
    'test/core',
  ];

  final widgetTests = [
    'test/features',
  ];

  final integrationTests = [
    'test/integration',
  ];

  // Run unit tests
  group('Unit Tests', () {
    for (final testPath in unitTests) {
      test(testPath, () async {
        await Process.run('flutter', [
          'test',
          '--coverage',
          testPath,
        ]).then((result) {
          if (result.exitCode != 0) {
            exit(result.exitCode);
          }
        });
      });
    }
  });

  // Run widget tests
  group('Widget Tests', () {
    for (final testPath in widgetTests) {
      test(testPath, () async {
        await Process.run('flutter', [
          'test',
          '--coverage',
          testPath,
        ]).then((result) {
          if (result.exitCode != 0) {
            exit(result.exitCode);
          }
        });
      });
    }
  });

  // Run integration tests
  group('Integration Tests', () {
    for (final testPath in integrationTests) {
      test(testPath, () async {
        await Process.run('flutter', [
          'test',
          '--coverage',
          testPath,
        ]).then((result) {
          if (result.exitCode != 0) {
            exit(result.exitCode);
          }
        });
      });
    }
  });

  // Generate coverage report
  test('Generate Coverage Report', () async {
    // Read coverage report
    final reportFile = File('coverage/lcov.info');
    final reportContent = await reportFile.readAsString();

    // Calculate coverage percentage
    final lines = reportContent.split('\n');
    int hitLines = 0;
    int totalLines = 0;

    for (final line in lines) {
      if (line.startsWith('SF:')) {
        // Skip excluded files
        final filePath = line.substring(3);
        if (TestConfig.shouldExcludeFromCoverage(filePath)) {
          continue;
        }
      } else if (line.startsWith('DA:')) {
        final parts = line.split(',');
        final hits = int.parse(parts[1]);
        totalLines++;
        if (hits > 0) {
          hitLines++;
        }
      }
    }

    final coveragePercentage = totalLines > 0 ? hitLines / totalLines : 0.0;

    // Print coverage report

    // Check if coverage meets targets
    if (coveragePercentage < TestConfig.unitTestCoverageTarget) {
      exit(1);
    } else {
    }


    // Generate HTML report
    await Process.run('genhtml', [
      'coverage/lcov.info',
      '--output-dir=coverage/html',
    ]);

  });
}
