import 'dart:io';

import 'package:yaml/yaml.dart';

Future<Map<String, dynamic>> data = Future(() async {
  var dir = Directory('src/_data');
  final vars = <String, dynamic>{};

  for (var entry in dir.listSync()) {
    if (entry is File && entry.path.endsWith('.yml')) {
      var content = await entry.readAsString();
      vars[entry.path.substring(dir.path.length + 1).replaceAll('.yml', '')] = loadYaml(content);
    }
  }

  return vars;
});
