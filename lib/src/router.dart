import 'dart:io';

import 'package:dart_dev/src/markdown_page.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

Future<Component> getRouter() async {
  var routes = await loadRoutes(Directory('src/content'));
  //printRoutes(routes);

  return Router(
    routes: routes,
    errorBuilder: (context, state) {
      print('NOT FOUND: ${state.location}');
      return const Text('NOT FOUND');
    },
  );
}

Future<List<RouteBase>> loadRoutes(Directory dir, [String path = '', bool isTopLevel = true]) async {
  Route? index;
  var routes = <RouteBase>[];

  var hasIndex = File(dir.path + '/index.md').existsSync();

  for (final entry in dir.listSync()) {
    var name = entry.path.substring(dir.path.length + 1);

    if (name.startsWith('_')) continue;
    if (name == 'get-dart') continue;

    if (entry is File && name.endsWith('.md')) {
      var isIndex = name.endsWith('index.md');
      var route = Route(
        path: (isTopLevel ? '/' : '') +
            (isIndex ? path : ((hasIndex || path.isEmpty ? '' : '$path/') + name.replaceFirst('.md', ''))),
        builder: (context, state) => MarkdownPage(path: entry.path),
      );
      if (isIndex) {
        index = route;
      } else {
        routes.add(route);
      }
    }
    if (entry is Directory) {
      var subRoutes = await loadRoutes(
          entry,
          (isTopLevel ? '/' : '') +
              (hasIndex
                  ? name
                  : path.isNotEmpty
                      ? path + '/' + name
                      : name),
          false);
      routes.addAll(subRoutes);
    }
  }

  if (isTopLevel) {
    return [
      if (index != null) index,
      ...routes,
    ];
  }

  assert(!hasIndex || index != null);
  if (index != null) {
    assert(hasIndex);
    return [
      Route(
        path: index.path,
        builder: index.builder,
        routes: routes,
      )
    ];
  } else {
    assert(!hasIndex);
    return routes;
  }
}

void printRoutes(List<RouteBase> routes, [String padding = '']) {
  for (final route in routes) {
    if (route is Route) {
      print('$padding${route.path}');
      printRoutes(route.routes, padding + '  ');
    }
  }
}
