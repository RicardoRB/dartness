# Quick start

## Example

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```bash
$ dart run bin/dartness.dart
Server listening on port 8080
```

## Prerequisites

Install [Dart SDK](https://dart.dev/get-dart) version >=2.17.1

```bash
$ dart --version            
Dart SDK version: 2.17.3 (stable)
```

## Creating a new project

```bash
$ dart create -t console cli
```

1Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness: ^0.2.0-alpha
```

2.Create the file in "bin/main.dart"

```dart
import 'package:dartness/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
  );
  await app.create();
}

```

3.Run the server

```bash
$ dart run bin/main.dart
Server listening on port 3000
```

