import 'dart:async';

import 'package:jaspr/browser.dart' as jaspr;

import 'versions_table.dart';

Future<void> runApp() async {
  for (final channel in ['stable', 'beta', 'dev']) {
    jaspr.runApp(VersionsTable(channel: channel), attachTo: '.archive-table[data-channel="$channel"]');
  }
}
