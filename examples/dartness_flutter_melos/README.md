# Dartness with Flutter

## Introduction

Dartness was designed at first with the main objective of building a fast and scalable server-side application that may
easy to share code when developing with Flutter or other Dart Front-End framework also to make it easy for people coming
from the javascript world using Nest and java world using spring boot to be able to develop and create a fast full-stack
application.

## Mono-repository

In this section, we will see how to use the Dartness framework in a single repository
with [Flutter](https://flutter.dev/), and we will use [Melos](https://melos.invertase.dev/) to manage our projects.

_I assume you have flutter and melos installed._

### Example
You have an example
in [/examples/dartness_flutter_melos/](https://github.com/RicardoRB/dartness/tree/master/examples/dartness_flutter_melos)
folder.

### Create a new project

Create a new folder (this is where our repository's root will be located).
In the same folder create 3 folders:

- apps
- commons
- servers

Go to the apps folder and create a new flutter project as follows:

```bash
$ flutter create my_app
```

After that go to the servers folder and create a new dart project as follows:

```bash
$ dart create my_server
```

You can create an optional package inside the commons folder.

The tree of the project will be as follows:

```
├── my_project
│   ├── apps
│   │   └── my_app
│   ├── commons
│   │   └── my_package (optional)
│   └── servers
│       └── my_server
```

### Configure the project

In the root folder (`my_project`) create a file **melos.yml** with the following value:

```yaml
name: my_project

command:
  bootstrap:
    usePubspecOverrides: true

packages:
  - apps/**
  - commons/**
  - servers/**
scripts:
  pub:get: melos apps:pub:get && melos dart:pub:get
  apps:pub:get: melos exec --flutter -- flutter pub get .
  dart:pub:get: melos exec --no-flutter -- dart pub get .

  test: melos apps:test && melos dart:test
  apps:test: melos exec --dir-exists=test --flutter -- flutter test
  dart:test: melos exec --dir-exists=test --no-flutter -- dart test

  analyze: melos apps:analyze && melos dart:analyze
  apps:analyze: melos exec --flutter -- flutter analyze
  dart:analyze: melos exec --no-flutter -- dart analyze

  format: dart format .

  build_runner:build: melos apps:build_runner:build && melos dart:build_runner:build
  apps:build_runner:build: melos exec --flutter -- flutter pub run build_runner build --delete-conflicting-outputs
  dart:build_runner:build: melos exec --no-flutter -- dart run build_runner build --delete-conflicting-outputs

  format:check:
    exec: dart format --set-exit-if-changed .

```

This will create the basic commands to run with melos, you can check more commands in
the [melos documentation](https://melos.invertase.dev/docs/).

In order to link the projects and install all package dependencies, you need to run the following command:

```bash
$ melos bootstrap

  └> C:\Users\user\my_project

Running "flutter pub get" in workspace packages...
  ✓ zerka_backend
    └> servers/my_project_backend
  ✓ zerka_commons
    └> commons/my_project_commons
  ✓ zerka_app
    └> apps/my_project_app           
  > SUCCESS                     
                                
Generating IntelliJ IDE files...
  > SUCCESS

 -> 3 packages bootstrapped

```

### Run the project

Now you can run the flutter and the dartness projects as follow.

#### Run Dartness

```bash
$ dart run servers/my_server/bin/my_server.dart
```

#### Run Flutter

```bash
$  flutter run apps/my_app/lib/main.dart
```

## Conclusion

Having a single repository make us easier to manage our projects and to share code adding our projects as dependency
into the `pubspec.yml`. We can use the same code in different projects, and as simple as run our backend and our app we
can communicate them in our local environment.
