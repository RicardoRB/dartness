# Introduction

<p align="center">Dartness is a progressive dart framework for building efficient and scalable server-side applications.</p>

## Description

Dartness is a framework for building efficient, scalable dart server-side applications. It provides an easy and quick
way to develop modern standalone server.

Under the hood, Dartness makes use of [shelf](https://github.com/dart-lang/shelf).

Inspired by [Spring Boot](https://github.com/spring-projects/spring-boot) and [Nest](https://github.com/nestjs/nest)
frameworks

## Installation

Install [Dart SDK](https://dart.dev/get-dart) version >=2.17.0

```bash
$ dart --version            
Dart SDK version: 2.17.3 (stable)
```

## Creating a new project

```bash
$ dart create -t console your_project_name
```

1. Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.2.0-alpha
```

2. Create the file in "bin/main.dart"

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

3. Run the server

```bash
$ dart run bin/main.dart
Server listening on port 3000
```

## Example

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run example/main.dart
Server listening on port 3000
```

## Docs and more

You can check the documentation at [dartness docs](https://ricardorb.github.io/dartness/)

## TODO

1. HTTP
    - Controllers
        - <del>Bind annotations</del>
        - <del>Header</del>
        - <del>Body</del>
        - <del>Param</del>
        - <del>Query</del>
    - <del>Middleware</del>
    - <del>Interceptor</del>
    - Websockets
2. Exceptions
    - <del>Exception Handler</del>
3. Security
    - Roles
    - CORS
4. Dependency Injection
    - Injectable
5. Scheduling
    - Annotation
6. Database
    - ORM
    - Repository
7. Testing
8. CLI