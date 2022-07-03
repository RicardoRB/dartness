# First steps

In this set of articles, you'll learn the core fundamentals of Dartness. To get familiar with the essential building
blocks
of Dartness applications, we'll build a basic CRUD application with features that cover a lot of ground at an
introductory
level.

## Prerequisites

Please make sure that [Dart SDK](https://dart.dev/get-dart) version >=2.17.1 is installed on your machine.

## Setup

```bash
$ dart create -t console your_project_name
```

1. Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.2.0-alpha
```

2. Create the file in "bin/main.dart" or whatever file that runs your application.

```dart
import 'package:dartness_server/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
  );
  await app.create();
}
```

## Adding a controller

In order to create a controller, you need to import it and add it to the `Dartness` list. You can do it in two ways
adding it when you create the app or before creating the app by `app.addController(controller)`.

```dart
import 'package:dartness_server/dartness.dart';

import 'example_controller.dart';

void main() async {
  final app = Dartness(
    port: 3000,
    controllers: [ExampleController()],
  );
  app.addController(Example2Controller());
  await app.create();
}
```

## Running the application

Once the installation process is complete, you can run the following command at your OS command prompt to start the
application listening for inbound HTTP requests:

```bash
$ dart run bin/main.dart
Server listening on port 3000
```