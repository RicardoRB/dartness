# Quick start

## Example

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```bash
$ dart run bin/dartness.dart
Server listening on port 8080
```

## Prerequisites

Install [Dart SDK](https://dart.dev/get-dart) version >=2.17.0

```bash
$ dart --version            
Dart SDK version: 2.17.3 (stable)
```

## Creating a new project

```bash
$ dart create -t console your_project_name
```

1Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.4.3-alpha
```

2.Create the file in "bin/main.dart"

```dart
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

