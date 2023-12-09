# Modules

A module is a class that provides metadata that Dartness makes use
of to organize the application structure.

Each application has at least one module, a root module. The root module is the starting point Dartness uses to build
the application graph - the internal data structure Dartness uses to resolve module and provider relationships and
dependencies. While very small applications may theoretically have just the root module, this is not the typical case.
We want to emphasize that modules are strongly recommended as an effective way to organize your components. Thus, for
most applications, the resulting architecture will employ multiple modules, each encapsulating a closely related set of
capabilities.

The `Module` class has properties to describe the module:

| Attribute                      | Description                                                                                                                                                                                          |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `providers`                    | the providers that will be instantiated by the Nest injector and that may be shared at least across this module                                                                                      |
| `controllers`                  | the set of controllers defined in this module which have to be instantiated                                                                                                                          |
| `imports`                      | the list of imported modules that export the providers which are required in this module                                                                                                             |
| `exports` (under construction) | the subset of providers that are provided by this module and should be available in other modules which import this module. You can use either the provider itself or just its token (provide value) |

## Feature modules

The `CityController` and `CityService` belong to the same application domain. As they are closely related, it makes
sense to move them into a feature module. A feature module simply organizes code relevant for a specific feature,
keeping code organized and establishing clear boundaries. This helps us manage complexity and develop with SOLID
principles, especially as the size of the application and/or team grow.

To demonstrate this, we'll create the `CityModule`.

```dart

const cityModule = Module(
  metadata: ModuleMetadata(
    controllers: [
      ProviderMetadata(
        classType: CityController,
      ),
    ],
    providers: [
      ProviderMetadata(
        classType: CityService,
      ),
    ],
  ),
);
```

Above, we defined the `CityModule` in the `cities_module.dart` file, and moved everything related to this module into
the cities' directory. The last thing we need to do is import this module into the root module (the AppModule, defined
in the `app.dart` file).

```dart
import 'cities/city_module.dart';

@Application(
  module: Module(
    metadata: ModuleMetadata(
      imports: [cityModule],
    ),
  ),
)
class App {}
```

Here is how our directory structure looks now:

```
├── src
│ ├── cities
│ │ ├── cities_service.dart
│ │ ├── cities_service.g.dart
│ │ ├── cities_controller.dart
│ │ ├── cities_controller.g.dart
│ │ ├── cities_module.dart
│ ├── app.dart
│ ├── app.g.dart
```

In this example our module is global since we declared it in a global variable.