import 'package:jaspr/jaspr.dart';

Component build(List<String> args, Component child) {
  return div(id: "tab-sdk-install-${args[0]}", classes: "tabs__content${args[0] == 'windows' ? ' current' : ''}", [
    child,
  ]);
}
