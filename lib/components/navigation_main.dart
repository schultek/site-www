import 'package:dart_dev/data/variables.dart';
import 'package:jaspr/jaspr.dart';

class NavigationMain extends StatelessComponent {
  const NavigationMain({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    vars['page_url_path'] =
        '/*' + (vars['page']['url'] as String).replaceAll(RegExp(r'/index$|/index\.html$|\.html$|/$'), '') + '/';

    yield nav(id: 'mainnav', classes: 'site-header', [
      div(id: 'menu-toggle', [
        i(classes: 'material-symbols', [text('menu')]),
      ]),
      a(href: '/', classes: 'brand', attributes: {
        'title': vars['site']['title']
      }, [
        img(src: '/assets/img/logo/logo-white-text.svg', attributes: {'alt': vars['site']['title']}),
      ]),
      ul(classes: 'navbar', [
        // If you edit this list, also edit NavigationSide (mobile).
        li([
          a(
              href: '/overview',
              classes: 'nav-link ${vars['page_url_path'].contains('/*/overview/') ? 'active' : ''}',
              [text('Overview')]),
        ]),
        li(classes: 'mainnav__get-started', [
          a(
              href: '/guides',
              classes:
                  'nav-link ${vars['page_url_path'].contains('/*/guides/') || vars['page_url_path'].contains('/*/language/') ? 'active' : ''}',
              [text('Docs')]),
        ]),
        li([
          a(
              href: '/community',
              classes: 'nav-link ${vars['page_url_path'].contains('/*/community/') ? 'active' : ''}',
              [text('Community')]),
        ]),
        li([
          a(href: '/#try-dart', classes: 'nav-link', [text('Try Dart')]),
        ]),
        li([
          a(href: '/get-dart', classes: 'nav-link', [text('Get Dart')]),
        ]),
        li(classes: 'searchfield', [
          form(action: '/search', classes: 'site-header__search form-inline', id: 'cse-search-box', [
            input(type: InputType.hidden, name: 'cx', value: '011220921317074318178:_yy-tmb5t_i', []),
            input(type: InputType.hidden, name: 'ie', value: 'UTF-8', []),
            input(type: InputType.hidden, name: 'hl', value: 'en', []),
            input(
                type: InputType.search,
                classes: 'site-header__searchfield form-control search-field',
                name: 'q',
                id: 'search-main',
                attributes: {'autocomplete': 'off', 'placeholder': 'Search', 'aria-label': 'Search'},
                []),
          ]),
        ]),
      ]),
    ]);
  }
}
