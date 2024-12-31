To develop real apps,
you need an SDK.
You can either download the Dart SDK directly
(as described below)
or [download the Flutter SDK,][]
which includes the full Dart SDK.

[download the Flutter SDK,]: {{site.flutter-docs}}/get-started/install

{% os_tabs %}
{% os_tab 'windows' %}

  Use [Chocolatey](https://chocolatey.org) to install a stable release of
  the Dart SDK.

  :::important
  These commands require administrator privileges.
  If you need help on starting an administrator-level command prompt,
  try a search like
  <em><a href="https://www.google.com/search?q=cmd+admin"
  target="blank">cmd admin</a>.</em>
  :::

  To install the Dart SDK:

  ```ps
  C:\> choco install dart-sdk
  ```

{% endos_tab %}

{% os_tab 'linux' %}

  You can use APT to install the Dart SDK on Linux.

  1. Perform the following one-time setup:
  
     ```console
     $ sudo apt-get update
     $ sudo apt-get install apt-transport-https
     $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
     $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
     ```

  2. Install the Dart SDK:
  
     ```console
     $ sudo apt-get update
     $ sudo apt-get install dart
     ```

{% endos_tab %}

{% os_tab 'mac' %}

  With [Homebrew,](https://brew.sh/)
  installing Dart is easy.

  ```console
  $ brew tap dart-lang/dart
  $ brew install dart
  ```

{% endos_tab %}

:::important
For more information, including how to **adjust your `PATH`**, see
[Get the Dart SDK](/get-dart).
:::
