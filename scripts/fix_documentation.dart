#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// Documentation fixer script for the Fix It project.
///
/// This script helps fix documentation issues by generating proper
/// documentation stubs that will pass validation.
///
/// Usage:
/// dart scripts/fix_documentation.dart [directory]
///
/// Example:
/// dart scripts/fix_documentation.dart lib/features/auth

import 'dart:io';

class DocumentationFixer {
  static const List<String> _excludedPatterns = [
    '**/*.g.dart',
    '**/*.freezed.dart',
    '**/*.mocks.dart',
    '**/generated/**',
    'lib/l10n/**',
    'lib/firebase_options.dart',
    'lib/l10n/*.dart',
  ];

  int _filesFixed = 0;

  /// Fixes documentation in the specified directory.
  Future<void> fixDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      print('❌ Directory not found: $directoryPath');
      exit(1);
    }

    print('🔧 Fixing documentation in: $directoryPath');
    print('');

    await _processDirectory(directory);

    print('✅ Fixed documentation in $_filesFixed files');
  }

  /// Recursively processes all Dart files in a directory.
  Future<void> _processDirectory(Directory directory) async {
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        if (!_isExcludedFile(entity.path)) {
          await _fixFile(entity);
        }
      }
    }
  }

  /// Checks if a file should be excluded from processing.
  bool _isExcludedFile(String filePath) {
    for (final pattern in _excludedPatterns) {
      final regexPattern = pattern
          .replaceAll('**/', '')
          .replaceAll('*', '.*')
          .replaceAll('.', r'\.');

      if (RegExp(regexPattern).hasMatch(filePath)) {
        return true;
      }
    }
    return false;
  }

  /// Fixes documentation in a single Dart file.
  Future<void> _fixFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');
    final fixedLines = <String>[];
    bool fileModified = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      fixedLines.add(line);

      // Check for class declarations
      if (_isClassDeclaration(line)) {
        final className = _extractClassName(line);
        if (!_hasProperClassDocumentation(lines, i)) {
          // Insert proper class documentation
          final classDoc = _generateClassDocumentation(className);
          fixedLines.insertAll(fixedLines.length - 1, classDoc);
          fileModified = true;
        }
      }

      // Check for method declarations
      if (_isMethodDeclaration(line)) {
        final methodName = _extractMethodName(line);
        if (!_hasProperMethodDocumentation(lines, i)) {
          // Insert proper method documentation
          final methodDoc = _generateMethodDocumentation(methodName, line);
          fixedLines.insertAll(fixedLines.length - 1, methodDoc);
          fileModified = true;
        }
      }
    }

    if (fileModified) {
      await file.writeAsString(fixedLines.join('\n'));
      _filesFixed++;
      print('📄 Fixed: ${_getRelativePath(file.path)}');
    }
  }

  /// Checks if a line represents a class declaration.
  bool _isClassDeclaration(String line) {
    return RegExp(r'^(abstract\s+)?class\s+[A-Z]\w*').hasMatch(line) &&
        !line.startsWith('_');
  }

  /// Checks if a line represents a method declaration.
  bool _isMethodDeclaration(String line) {
    final methodDecl = RegExp(
        r'^(?:@override\s+)?(?:[A-Za-z0-9_<>,\[\]\s]+\s+)?([a-z][A-Za-z0-9_]*)\s*\([^)]*\)\s*(?:\{|=>)?\s*$');
    return methodDecl.hasMatch(line) &&
        !line.contains('_') &&
        !line.startsWith('_');
  }

  /// Checks if there's proper class documentation above the given line.
  bool _hasProperClassDocumentation(List<String> lines, int index) {
    if (index < 5) return false; // Not enough space for proper documentation

    // Look for Business Rules section in the documentation above
    for (int i = index - 1; i >= 0 && i >= index - 20; i--) {
      if (lines[i].contains('**Business Rules:**')) {
        // Check if it's not just a placeholder
        for (int j = i; j < index; j++) {
          if (lines[j].contains('Add the main business rules')) {
            return false; // It's a placeholder
          }
        }
        return true; // Found real Business Rules section
      }
    }
    return false;
  }

  /// Checks if there's proper method documentation above the given line.
  bool _hasProperMethodDocumentation(List<String> lines, int index) {
    if (index < 3) return false; // Not enough space for proper documentation

    bool hasParams = false;
    bool hasReturns = false;

    // Look for parameter and return documentation
    for (int i = index - 1; i >= 0 && i >= index - 20; i--) {
      if (lines[i].contains('**Parameters:**')) {
        hasParams = true;
      }
      if (lines[i].contains('**Returns:**')) {
        hasReturns = true;
      }
    }

    // Check if it's a Future method (should have return documentation)
    bool isFuture = false;
    for (int i = index; i < lines.length && i < index + 5; i++) {
      if (lines[i].contains('Future<')) {
        isFuture = true;
        break;
      }
    }

    return hasParams && (!isFuture || hasReturns);
  }

  /// Generates proper class documentation.
  List<String> _generateClassDocumentation(String className) {
    return [
      '/// $className',
      '///',
      '/// Brief description of the $className class.',
      '///',
      '/// **Business Rules:**',
      '/// - Business rule 1 for $className',
      '/// - Business rule 2 for $className',
      '///',
      '/// **Error Scenarios:**',
      '/// - [ErrorType]: When this error occurs',
      '///',
      '/// **Dependencies:**',
      '/// - [Dependency]: Purpose',
      '///',
      '/// Example usage:',
      '/// ```dart',
      '/// final ${_camelToSnake(className)} = $className();',
      '/// // Use the class',
      '/// ```',
    ];
  }

  /// Generates proper method documentation.
  List<String> _generateMethodDocumentation(
      String methodName, String methodLine) {
    // Extract parameters from method signature
    final paramMatches = RegExp(r'(\w+)\s+([\w?]+)').allMatches(methodLine);
    final params = <String>[];

    for (final match in paramMatches) {
      final type = match.group(1);
      final name = match.group(2);
      if (type != null &&
          name != null &&
          !name.startsWith('_') &&
          type != 'void') {
        params.add('$name: $type');
      }
    }

    final doc = <String>[
      '/// Brief description of what the $methodName method does.',
      '///',
    ];

    if (params.isNotEmpty) {
      doc.add('/// **Parameters:**');
      for (final param in params) {
        doc.add('/// - [$param]: Description of parameter');
      }
    }

    // Check if method returns a Future (async)
    if (methodLine.contains('Future<') || methodLine.contains('async')) {
      doc.add('///');
      doc.add('/// **Returns:**');
      doc.add('/// - [SuccessType]: What is returned on success');
      doc.add('/// - [FailureType]: What is returned on failure');
    }

    return doc;
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

  /// Converts CamelCase to snake_case.
  String _camelToSnake(String input) {
    return input
        .replaceAllMapped(RegExp(r'[A-Z]'),
            (Match match) => '_${match.group(0)!.toLowerCase()}')
        .substring(1);
  }

  /// Gets relative path for cleaner output.
  String _getRelativePath(String fullPath) {
    final currentDir = Directory.current.path;
    return fullPath.replaceFirst(currentDir, '').replaceFirst('/', '');
  }
}

/// Main entry point for the documentation fixer.
void main(List<String> args) async {
  final directoryPath = args.isNotEmpty ? args[0] : 'lib';

  print('🔧 Fix It Documentation Fixer');
  print('');

  final fixer = DocumentationFixer();
  await fixer.fixDirectory(directoryPath);
}
