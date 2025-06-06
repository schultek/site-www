---
title: sdk_version_is_expression_in_const_context
description: >-
  Details about the sdk_version_is_expression_in_const_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The use of an is expression in a constant context wasn't supported until
version 2.3.2, but this code is required to be able to run on earlier versions._

## Description

The analyzer produces this diagnostic when an `is` expression inside a
[constant context][] is found in code that has an SDK constraint whose
lower bound is less than 2.3.2. Using an `is` expression in a
[constant context][] wasn't supported in earlier versions, so this code
won't be able to run against earlier versions of the SDK.

## Example

Here's an example of a pubspec that defines an SDK constraint with a lower
bound of less than 2.3.2:

```yaml
environment:
  sdk: '>=2.1.0 <2.4.0'
```

In the package that has that pubspec, code like the following produces
this diagnostic:

```dart
const Object x = 4;
const y = [!x is int!] ? 0 : 1;
```

## Common fixes

If you don't need to support older versions of the SDK, then you can
increase the SDK constraint to allow the expression to be used:

```yaml
environment:
  sdk: '>=2.3.2 <2.4.0'
```

If you need to support older versions of the SDK, then either rewrite the
code to not use the `is` operator, or, if that isn't possible, change the
code so that the `is` expression isn't in a
[constant context][]:

```dart
const Object x = 4;
var y = x is int ? 0 : 1;
```

[constant context]: /resources/glossary#constant-context
