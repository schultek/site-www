import 'package:jaspr/jaspr.dart';

Component build(List<String> args) {
  return ul(classes: "tabs__top-bar", [
    li(classes: "tab-link current", attributes: {"data-tab": "tab-sdk-install-windows"}, [text("Windows")]),
    li(classes: "tab-link", attributes: {"data-tab": "tab-sdk-install-linux"}, [text("Linux")]),
    li(classes: "tab-link", attributes: {"data-tab": "tab-sdk-install-mac"}, [text("Mac")]),
  ]);
}
