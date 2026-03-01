import 'dart:io';

void main() {
  final dir = Directory('lib');
  for (final file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      var content = file.readAsStringSync();
      var changed = false;
      if (content.contains(r'\${')) {
        content = content.replaceAll(r'\${', r'${');
        changed = true;
      }
      if (content.contains(r'\$')) {
        content = content.replaceAll(r'\$', r'$');
        changed = true;
      }
      if (changed) {
        file.writeAsStringSync(content);
        print('Fixed ${file.path}');
      }
    }
  }
}
