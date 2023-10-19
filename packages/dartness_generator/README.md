# Introduction

dartness_generator is used with dartness_server in order to provide the code generation for some annotations

## Generating code

1. Add `dartness_generator` together with `build_runner` in dev_dependencies also add dartness_server in the dependency
   section in the pubspec.yaml

```yaml
dependencies:
  dartness_server: ^0.5.0-alpha

dev_dependencies:
  build_runner: ^2.2.0
  dartness_generator: ^0.4.6-alpha
```

2. Add the corresponding `part '.g.dart'` to your classes, otherwise the new code won't be generated, you can find an
   example in the following code:

```dart

part 'city_controller.g.dart';

@Controller('/cities')
class CitiesController {
  @Get()
  String getCities() {
    return 'This action returns a list of cities';
  }
}
```

3. Go to the root of your project and execute the following command:

```bash
$ dart run build_runner build
```
