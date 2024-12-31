import 'package:jaspr/jaspr.dart';

Component build(List<String> args) {
  final channel = args[0];
  return div(classes: "archive-table", attributes: {
    'data-channel': channel
  }, [
    ArchivesTable(channel: channel, versions: [
      ArchivesTable.templateRow(channel),
    ]),
  ]);
}

typedef VersionRow = ({
  String version,
  String? ref,
  String os,
  String arch,
  String date,
  List<({String label, String url, bool hasSha256})> archives,
});

class ArchivesTable extends StatelessComponent {
  const ArchivesTable({
    required this.channel,
    this.versions = const [],
    this.versionOptions = const [],
    this.selectedVersion,
    this.selectedOs,
    this.onSelectVersion,
    this.onSelectOs,
  });

  static VersionRow templateRow(String channel) {
    return (
      version: switch (channel) {
        'stable' => '0.0.0',
        'beta' => '0.0.0-0.0.beta',
        'dev' => '0.0.0-0.0.dev',
        _ => '0.0.0',
      },
      ref: 'ref 00000',
      os: '---',
      arch: '---',
      date: '01/01/1970',
      archives: [],
    );
  }

  final String channel;
  final List<VersionRow> versions;
  final List<String> versionOptions;
  final String? selectedVersion;
  final String? selectedOs;
  final void Function(String)? onSelectVersion;
  final void Function(String)? onSelectOs;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield form(classes: 'form-inline', [
      div(classes: 'form-group select', [
        label(htmlFor: '${channel}-versions', [text('Version:')]),
        select(id: '${channel}-versions', value: selectedVersion, onChange: (values) {
          onSelectVersion?.call(values.first);
        }, [
          for (final version in versionOptions) option(value: version, [text(version)]),
        ]),
      ]),
      div(classes: 'form-group select', [
        label(htmlFor: '${channel}-os', [text('OS:')]),
        select(id: '${channel}-os', value: selectedOs, onChange: (values) {
          onSelectOs?.call(values.first);
        }, [
          option(value: 'all', [text('All')]),
          option(value: 'macos', id: '${channel}-macos', classes: 'macos-option', [text('macOS')]),
          option(value: 'linux', id: '${channel}-linux', classes: 'linux-option', [text('Linux')]),
          option(value: 'windows', id: '${channel}-windows', classes: 'windows-option', [text('Windows')]),
        ]),
      ]),
    ]);

    yield table(id: channel, classes: 'table', [
      thead([
        tr([
          th([text('Version')]),
          th([text('OS')]),
          th([text('Architecture')]),
          th([text('Release date')]),
          th([text('Downloads')]),
        ]),
      ]),
      tbody([
        for (final version in versions)
          tr(
            classes: selectedOs == null ||
                    selectedOs == 'all' ||
                    version.os == '---' ||
                    selectedOs == version.os.toLowerCase()
                ? null
                : 'hidden',
            attributes: {'data-version': version.version, 'data-os': version.os.toLowerCase()},
            [
              DomComponent(tag: 'td', children: [
                text(version.version),
                if (version.ref != null) span(classes: "muted", [text(" (${version.ref})")])
              ]),
              DomComponent(tag: 'td', children: [text(version.os)]),
              DomComponent(tag: 'td', children: [text(version.arch)]),
              DomComponent(tag: 'td', children: [text(version.date)]),
              DomComponent(tag: 'td', classes: "archives", children: [
                for (final archive in version.archives) ...[
                  if (archive != version.archives.first) br(),
                  a(href: archive.url, [text(archive.label)]),
                  if (archive.hasSha256) a(href: '${archive.url}.sha256sum', [text(' (SHA-256)')]),
                ],
              ]),
            ],
          ),
      ]),
    ]);
  }
}
