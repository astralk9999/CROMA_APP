import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  final regex = RegExp(r'(?<![a-zA-Z0-9_])Colors\.black(?![0-9a-zA-Z_])');
  int count = 0;
  
  for (final file in files) {
    String content = file.readAsStringSync();
    if (regex.hasMatch(content)) {
      content = content.replaceAll(regex, 'const Color(0xFF202020)');
      file.writeAsStringSync(content);
      // print('Modificando: ${file.path}');
      count++;
    }
  }
  print('Updated $count files.');
}
```
