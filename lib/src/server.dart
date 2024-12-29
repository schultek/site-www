import 'dart:io';

import 'package:jaspr/server.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

HttpServer? server;

void run(Component app) async {
  await server?.close(force: true);

  var proxy = proxyHandler('http://localhost:4000');
  var appHandler = serveApp((request, render) async {
    var response = await render(app);
    var content = await response.readAsString();
    if (content.contains('<body>NOT FOUND</body>')) {
      return proxy(request.change(body: ''));
    }
    return Response.ok(content, headers: {'Content-Type': 'text/html'});
  });
  var cascade = Cascade().add((request) {
    return appHandler(request.change(body: ''));
  }).add(proxy);

  var handler = const Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(cascade.handler);

  server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080, shared: true);

  // Enable content compression
  server!.autoCompress = true;

  print('Serving at http://${server!.address.host}:${server!.port}');
}
