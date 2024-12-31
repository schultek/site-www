import 'dart:io';

import 'package:cosmic_frontmatter/cosmic_frontmatter.dart';
import 'package:dart_dev/data/variables.dart';
import 'package:dart_dev/layouts/default.dart';
import 'package:dart_dev/src/data.dart';
import 'package:jaspr/server.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:liquid_engine/src/buildin_tags/include.dart';
import 'package:liquid_engine/src/model_io.dart';
import 'package:markdown/markdown.dart';

class MarkdownPage extends AsyncStatelessComponent {
  const MarkdownPage({required this.path});

  final String path;

  @override
  Stream<Component> build(BuildContext context) async* {
    var file = File(path);
    var content = await file.readAsString();

    var document = parseFrontmatter(content: content, frontmatterBuilder: (v) => v);

    var layout = document.frontmatter['layout'] ??= 'default';

    var liquidContext = Context.create();
    liquidContext.variables.addAll(document.frontmatter);
    liquidContext.variables.addAll(await data);
    liquidContext.variables.addAll({
      'page': {'url': path}
    });

    liquidContext.filters.addAll({
      'modulo': (input, args) {
        return input % args[0];
      },
    });
    liquidContext.tags.addAll({
      'render': Include.factory,
    });

    vars.clear();
    vars.addAll(liquidContext.variables);

    final template = Template.parse(liquidContext, Source(null, document.body, BuildPath(Uri(path: 'src/_includes/'))));

    final html = markdownToHtml(await template.render(liquidContext));

    final child = raw(html);
    yield switch (layout) {
      _ => DefaultLayout(content: child),
    };
  }
}
