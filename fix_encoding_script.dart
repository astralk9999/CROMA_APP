import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

void main() async {
  final file = File(
    'lib/features/admin/presentation/screens/admin_users_screen.dart',
  );
  if (!await file.exists()) {
    print('File not found');
    return;
  }

  try {
    final bytes = await file.readAsBytes();
    // UTF-16LE usually starts with 0xFF 0xFE
    // We can also just try to decode it
    String content;
    try {
      // Create a Uint16List from the bytes, assuming little endian
      final buffer = bytes.buffer.asUint16List();
      content = String.fromCharCodes(buffer);
      // Remove BOM if present (U+FEFF)
      if (content.startsWith('\uFEFF')) {
        content = content.substring(1);
      }
    } catch (e) {
      print('Failed to decode as UTF-16: $e');
      return;
    }

    await file.writeAsString(content, encoding: utf8);
    print('Successfully converted to UTF-8');
  } catch (e) {
    print('Error converting file: $e');
  }
}
