# Quick start

## Example

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```bash
$ dart run bin/example.dart
Server listening on port 8080
```

## Prerequisites

Install [Dart SDK](https://dart.dev/get-dart) version >=2.17.0

```bash
$ dart --version            
Dart SDK version: 3.0.0 (stable)
```

## Creating a new project

```bash
$ dart create -t console your_project_name
```

### 1.Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.5.1-alpha
dev_dependencies:
  dartness_generator: ^0.5.2-alpha
```

### 2.Create the file in "src/app.dart"

```dart
@Application()
class App {}
```

### 4.Generate the code

```bash
$ dart run build_runner build
```

### 5.Modify "bin/main.dart"
```dart
void main(List<String> args) async {
  await App().init();
}
```

### 6.Run the server

```bash
$ dart run bin/main.dart
Server listening on port 3000
```

