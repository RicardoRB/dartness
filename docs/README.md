# Introduction

Dartness is a dart framework for building efficient and scalable server-side applications.

## Description

Dartness is a framework for building efficient, scalable dart server-side applications. It provides an easy and quick
way to develop modern standalone server.

Under the hood, Dartness makes use of [shelf](https://github.com/dart-lang/shelf).

Inspired by [Spring Boot](https://github.com/spring-projects/spring-boot) and [Nest](https://github.com/nestjs/nest)
frameworks

## Goals

The following goals are the main objectives that Dartness needs to provide and why it was designed for:

* 🛠 **Full stack integration** with flutter or other dart front end frameworks
* 🤹‍♀️🤹‍♂️ **Easy and understandable** for people coming from other kind of technology
  as [Spring Boot](https://github.com/spring-projects/spring-boot) and [NestJS](https://github.com/nestjs/nest)
* ✏ **Simplicity**, it should be easy to know why and how to use every functionality
* 👨‍💻👩‍💻 **Community empowered**, where the community should be able to understand and maintain the dartness project by
  their own

## Examples

You can find different examples if you prefer to understand the code by yourself in
the [/examples folder](https://github.com/RicardoRB/dartness/tree/master/examples).

## Requisites

Install [Dart SDK](https://dart.dev/get-dart) version >=3.0.0

```bash
$ dart --version            
Dart SDK version: 3.0.0 (stable)
```

## Docs and more

You can check the documentation at [dartness docs](https://ricardorb.github.io/dartness/)

## Creating a new project

```bash
$ dart create -t console your_project_name
```

### 1. Add dartness into the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.5.1-alpha

dev_dependencies:
  build_runner: ^2.2.0
  dartness_generator: ^0.5.2-alpha
```


### 2.Create the file in "src/app.dart"

```dart
@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [],
      providers: [],
      exports: [],
      imports: [],
    ),
  ),
  options: DartnessApplicationOptions(
    port: int.fromEnvironment(
      'port',
      defaultValue: 8080,
    ),
  ),
)
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

## Example

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run example/main.dart
Server listening on port 3000
```

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
2. <del>Exceptions</del>
   - <del>Exception Handler</del>
3. Security
   - Roles
   - CORS
4. <del>Dependency Injection</del>
   - <del>Injectable</del>
5. Scheduling
   - Annotation
6. Database
   - ORM
   - Repository
7. Testing
8. CLI