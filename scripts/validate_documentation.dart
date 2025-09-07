#!/usr/bin/env dart

/// Documentation validation script for the Fix It project.
/// 
/// This script helps enforce documentation standards by analyzing
/// Dart files and checking for compliance with project requirements.
/// 
/// Usage:
/// dart scripts/validate_documentation.dart [directory]
/// 
/// Example:
/// dart scripts/validate_documentation.dart lib/features/auth

// ignore_for_file: avoid_print, unnecessary_string_escapes

import 'dart:io';

class DocumentationValidator {
  static const List<String> _requiredDocSections = [
    'Business Rules',
    'Error Scenarios',
    'Dependencies',
    'Example usage',
  ];

  static const List<String> _excludedPatterns = [
    '**/*.g.dart',
    '**/*.freezed.dart',
    '**/*.mocks.dart',
    '**/generated/**',
  ];

  int _filesChecked = 0;
  int _filesWithIssues = 0;
  final List<String> _issues = [];

  /// Validates documentation in the specified directory.
  Future<void> validateDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      print('❌ Directory not found: $directoryPath');
      exit(1);
    }

    print('🔍 Validating documentation in: $directoryPath');
    print('');

    await _processDirectory(directory);

    _printSummary();
  }

  /// Recursively processes all Dart files in a directory.
  Future<void> _processDirectory(Directory directory) async {
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        if (!_isExcludedFile(entity.path)) {
          await _validateFile(entity);
        }
      }
    }
  }

  /// Checks if a file should be excluded from validation.
  bool _isExcludedFile(String filePath) {
    for (final pattern in _excludedPatterns) {
      final regexPattern = pattern
          .replaceAll('**/', '')
          .replaceAll('*', '.*')
          .replaceAll('.', '\.');

      if (RegExp(regexPattern).hasMatch(filePath)) {
        return true;
      }
    }
    return false;
  }

  /// Validates documentation in a single Dart file.
  Future<void> _validateFile(File file) async {
    _filesChecked++;

    final content = await file.readAsString();
    final relativePath = _getRelativePath(file.path);

    List<String> fileIssues = [];

    // Check for public API documentation
    fileIssues.addAll(_checkPublicApiDocs(content, relativePath));

    // Check for class documentation quality
    fileIssues.addAll(_checkClassDocumentation(content, relativePath));

    // Check for method documentation
    fileIssues.addAll(_checkMethodDocumentation(content, relativePath));

    if (fileIssues.isNotEmpty) {
      _filesWithIssues++;
      print('📄 $relativePath');
      for (final issue in fileIssues) {
        print('  ❌ $issue');
        _issues.add('$relativePath: $issue');
      }
      print('');
    }
  }

  /// Checks for missing public API documentation.
  List<String> _checkPublicApiDocs(String content, String filePath) {
    List<String> issues = [];

    final lines = content.split('\n');
    bool inComment = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Track multi-line comments
      if (line.startsWith('/*')) inComment = true;
      if (line.endsWith('*/')) inComment = false;

      // Skip comments and empty lines
      if (line.startsWith('//') || line.isEmpty || inComment) continue;

      // Check for public class declarations
      if (_isPublicClassDeclaration(line)) {
        if (i == 0 || !_hasDocumentationAbove(lines, i)) {
          final className = _extractClassName(line);
          issues.add('Public class "$className" missing documentation');
        }
      }

      // Check for public method declarations
      if (_isPublicMethodDeclaration(line)) {
        if (!_hasDocumentationAbove(lines, i)) {
          final methodName = _extractMethodName(line);
          issues.add('Public method "$methodName" missing documentation');
        }
      }
    }

    return issues;
  }

  /// Checks the quality of class documentation.
  List<String> _checkClassDocumentation(String content, String filePath) {
    List<String> issues = [];

    final classMatches = RegExp(r'///.*?\nclass\s+(\w+)', 
        multiLine: true, dotAll: true).allMatches(content);

    for (final match in classMatches) {
      final docComment = match.group(0)!;
      final className = match.group(1)!;

      // Check for required documentation sections
      for (final section in _requiredDocSections) {
        if (!docComment.contains(section)) {
          issues.add('Class "$className" missing "$section" section');
        }
      }

      // Check for minimum documentation length
      if (docComment.length < 200) {
        issues.add('Class "$className" documentation too brief (< 200 chars)');
      }

      // Check for example usage
      if (!docComment.contains('```dart') && !docComment.contains('Example')) {
        issues.add('Class "$className" missing code examples');
      }
    }

    return issues;
  }

  /// Checks method documentation quality.
  List<String> _checkMethodDocumentation(String content, String filePath) {
    List<String> issues = [];

    final methodMatches = RegExp(
        r'///.*?\n\s*(Future<.*?>|\w+)\s+(\w+)\s*\(',
        multiLine: true, dotAll: true).allMatches(content);

    for (final match in methodMatches) {
      final docComment = match.group(0)!;
      final methodName = match.group(2)!;

      // Skip private methods
      if (methodName.startsWith('_')) continue;

      // Check for parameter documentation
      if (docComment.contains('required') && !docComment.contains('**')) {
        issues.add('Method "$methodName" parameters not properly documented');
      }

      // Check for return value documentation
      if (docComment.contains('Future<') && !docComment.contains('Returns')) {
        issues.add('Method "$methodName" return value not documented');
      }
    }

    return issues;
  }

  /// Checks if a line represents a public class declaration.
  bool _isPublicClassDeclaration(String line) {
    return RegExp(r'^(abstract\s+)?class\s+[A-Z]\w*').hasMatch(line) &&
           !line.startsWith('_');
  }

  /// Checks if a line represents a public method declaration.
  bool _isPublicMethodDeclaration(String line) {
    return (line.contains('Future<') || 
            RegExp(r'\w+\s+\w+\s*\(').hasMatch(line)) &&
           !line.contains('_') &&
           !line.startsWith('_');
  }

  /// Checks if there's documentation above the given line.
  bool _hasDocumentationAbove(List<String> lines, int index) {
    if (index == 0) return false;

    int checkIndex = index - 1;
    while (checkIndex >= 0 && lines[checkIndex].trim().isEmpty) {
      checkIndex--;
    }

    return checkIndex >= 0 && lines[checkIndex].trim().startsWith('///');
  }

  /// Extracts class name from a class declaration line.
  String _extractClassName(String line) {
    final match = RegExp(r'class\s+(\w+)').firstMatch(line);
    return match?.group(1) ?? 'Unknown';
  }

  /// Extracts method name from a method declaration line.
  String _extractMethodName(String line) {
    final match = RegExp(r'\w+\s+(\w+)\s*\(').firstMatch(line);
    return match?.group(1) ?? 'Unknown';
  }

  /// Gets relative path for cleaner output.
  String _getRelativePath(String fullPath) {
    final currentDir = Directory.current.path;
    return fullPath.replaceFirst(currentDir, '').replaceFirst('/', '');
  }

  /// Prints validation summary.
  void _printSummary() {
    print('📊 Documentation Validation Summary');
    print('─' * 40);
    print('Files checked: $_filesChecked');
    print('Files with issues: $_filesWithIssues');
    print('Total issues: ${_issues.length}');
    print('');

    if (_filesWithIssues == 0) {
      print('✅ All documentation looks good!');
    } else {
      print('⚠️  Please address the documentation issues above.');
      print('');
      print('💡 Tips for better documentation:');
      print('  • Add comprehensive class documentation with business rules');
      print('  • Include realistic usage examples with code blocks');
      print('  • Document all parameters and return values');
      print('  • Explain error scenarios and dependencies');
      print('  • Add inline comments for complex business logic');
    }

    // Exit with error code if issues found
    if (_filesWithIssues > 0) {
      exit(1);
    }
  }
}

/// Main entry point for the documentation validator.
void main(List<String> args) async {
  final directoryPath = args.isNotEmpty ? args[0] : 'lib';

  print('🔧 Fix It Documentation Validator');
  print('');

  final validator = DocumentationValidator();
  await validator.validateDirectory(directoryPath);
}
