// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

/// Simple asset validator: checks PNG signature and file size for images listed in assets/images/
/// Usage: dart run tools/validate_assets.dart

void main(List<String> args) async {
  final projectRoot = Directory.current.path;
  final assetsDir = Directory(
      '${projectRoot}${Platform.pathSeparator}assets${Platform.pathSeparator}images');
  if (!assetsDir.existsSync()) {
    stdout.writeln(
        'No assets/images directory found at: ${projectRoot}${Platform.pathSeparator}assets${Platform.pathSeparator}images');
    exit(1);
  }

  final files = assetsDir.listSync().whereType<File>().toList();
  if (files.isEmpty) {
    stdout.writeln('No files found in assets/images');
    exit(1);
  }

  var problems = 0;
  for (final file in files) {
    final bytes = await file.readAsBytes();
    final len = bytes.length;
    final name = file.path.split(Platform.pathSeparator).last;
    final isPng = len >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    if (!isPng) {
      stdout.writeln(
          'FAIL: $name — not a valid PNG (missing signature) — size=$len bytes');
      problems++;
      continue;
    }

    if (len < 200) {
      stdout.writeln(
          'WARN: $name — very small file (size=$len bytes) — verify content');
    }

    stdout.writeln('OK: $name — PNG, size=$len bytes');
  }

  if (problems > 0) {
    stdout.writeln('\nFound $problems problematic files.');
    exit(2);
  }

  stdout.writeln('\nAll checked images appear to be valid PNGs.');
}
