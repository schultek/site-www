import 'package:dart_dev/components/navigation_main.dart';
import 'package:dart_dev/data/variables.dart';
import 'package:jaspr/jaspr.dart';

class PageHeader extends StatelessComponent {
  const PageHeader({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield header(id: 'page-header', classes: 'site-header', [
      NavigationMain(),
      if (vars['obsolete'] == true) ...[
        div(classes: 'alert alert-warning', [
          h4(classes: 'text-center', [
            text('Some of the content of this page might be out of date.'),
          ]),
        ]),
      ],
    ]);
    if (vars['site']['show_banner'] == true) {
      // yield Banner();
    }
  }
}
