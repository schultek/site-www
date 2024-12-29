import 'dart:math';

import 'package:dart_dev/data/variables.dart';
import 'package:jaspr/jaspr.dart';

class Head extends StatelessComponent {
  const Head({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    String desc = vars['description'] ?? vars['site']!['description'];
    desc = desc.replaceAll('\n', ' ').substring(0, min(desc.length, 160));

    yield head([
      DomComponent(tag: 'meta', attributes: {'charset': 'UTF-8'}),
      DomComponent(tag: 'meta', attributes: {'http-equiv': 'x-ua-compatible', 'content': 'ie=edge'}),
      DomComponent(tag: 'meta', attributes: {'name': 'viewport', 'content': 'width=device-width, initial-scale=1.0'}),
      DomComponent(tag: 'meta', attributes: {'name': 'description', 'content': desc}),
      DomComponent(tag: 'title', children: [
        text('${vars['short-title'] ?? vars['title']} | ${vars['site']!['title']}'),
      ]),
      link(
          href: 'https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&display=swap',
          rel: 'stylesheet'),
      link(
          href: 'https://fonts.googleapis.com/css2?family=Google+Sans+Display:wght@400&display=swap',
          rel: 'stylesheet'),
      link(
          href: 'https://fonts.googleapis.com/css2?family=Google+Sans+Mono:wght@400;500;700&display=swap',
          rel: 'stylesheet'),
      link(
          href: 'https://fonts.googleapis.com/css2?family=Google+Sans+Text:wght@400;500;700&display=swap',
          rel: 'stylesheet'),
      link(
          href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0',
          rel: 'stylesheet'),
      link(rel: 'stylesheet', href: '/assets/css/main.css'),
    ]);
  }
}
