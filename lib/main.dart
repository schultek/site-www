import 'package:dart_dev/src/router.dart';
import 'package:dart_dev/src/server.dart';
import 'package:jaspr/server.dart';

void main() async {
  Jaspr.initializeApp();

  run(await getRouter());
}
