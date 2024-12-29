import 'package:dart_dev/components/head.dart';
import 'package:dart_dev/components/page_header.dart';
import 'package:dart_dev/data/variables.dart';
import 'package:jaspr/server.dart';

class DefaultLayout extends StatelessComponent {
  const DefaultLayout({required this.content});

  final Component content;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield html(attributes: {
      'lang': 'en'
    }, [
      const Head(),
      body(classes: '${vars['layout']}', [
        a(id: 'skip', href: "#site-content-title", [text('Skip to main content')]),
        PageHeader(),
        main_(id: 'page-content', [
          article(classes: 'content', [
            div(id: 'site-content-title', [
              h1([text(vars['title'])]),
            ]),
            content,
          ]),
        ]),
      ]),
    ]);
  }
}
