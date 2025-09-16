// Simple tool to attempt repair/re-encode of PNG assets flagged as corrupted.
// Usage: dart run tools/repair_png_assets.dart <path1> <path2> ...
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:convert';

void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart run tools/repair_png_assets.dart <file1> <file2> ...');
    exit(2);
  }

  for (final path in args) {
    final file = File(path);
    if (!file.existsSync()) {
      print('SKIP: $path (not found)');
      continue;
    }

    final bytes = await file.readAsBytes();
    // PNG signature
    final pngSig = <int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    int sigIndex = -1;
    for (int i = 0; i <= bytes.length - pngSig.length; i++) {
      bool ok = true;
      for (int j = 0; j < pngSig.length; j++) {
        if (bytes[i + j] != pngSig[j]) {
          ok = false;
          break;
        }
      }
      if (ok) {
        sigIndex = i;
        break;
      }
    }

    if (sigIndex == -1) {
      print('NO SIGNATURE: $path');
      // Try decode anyway; the image package sometimes decodes raw bytes
    } else if (sigIndex > 0) {
      print(
          'WARN: PNG signature found at offset $sigIndex for $path — trimming leading bytes');
    } else {
      print(
          'OK: PNG signature at offset 0 for $path — attempting decode/re-encode');
    }

    List<int> inputBytes = bytes;
    if (sigIndex > 0) {
      inputBytes = bytes.sublist(sigIndex);
    }

    try {
      // Ensure Uint8List
      final inputUint8 = Uint8List.fromList(inputBytes);
      final decoded = img.decodeImage(inputUint8);
      if (decoded == null) {
        print('FAIL: image.decodeImage returned null for $path');
        // Backup original
        final bak = File('$path.bak');
        if (!bak.existsSync()) await bak.writeAsBytes(bytes);
        // Create a small placeholder PNG (32x32 solid magenta) to avoid runtime crashes
        // Create a known-valid 1x1 transparent PNG (base64) as a safe placeholder
        const onePixelPngBase64 =
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=';
        final pngBytes = base64Decode(onePixelPngBase64);
        await file.writeAsBytes(pngBytes, flush: true);
        print('REPLACED_WITH_1x1_PNG: $path (backup: ${bak.path})');
        continue;
      }

      // Backup
      final bak = File('$path.bak');
      if (!bak.existsSync()) await bak.writeAsBytes(bytes);

      // Re-encode as PNG (lossless)
      final pngBytes = img.encodePng(decoded);
      await file.writeAsBytes(pngBytes, flush: true);
      print('FIXED: $path (backup: ${bak.path})');
    } catch (e, st) {
      print('ERROR processing $path: $e');
      // print stack for debugging
      print(st);
    }
  }
}
