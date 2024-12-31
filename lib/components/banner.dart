import 'package:jaspr/jaspr.dart';

Component build(List<String> args, Component child) {
  return div(classes: "banner", [
    p(classes: "banner__text", [
      child,
    ]),
  ]);
}
