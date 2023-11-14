# Providers

Providers refer to a core concept related to dependency injection. Providers are responsible for creating and managing
various dependencies and services that your application needs. These dependencies can include things like services,
repositories, configuration settings, database connections, and more. Dartness uses providers as a fundamental building
block for organizing and maintaining the components of your application.

## Services

To begin, we can create a basic `CityService` that will handle data storage and retrieval. This service is intended to
be utilized by the `CityController` and is a suitable candidate for registration as a provider.

```dart
class CityService {
  final List<City> cities = [];

  void create(City city) {
    cities.add(city);
  }

  List<City> findAll() {
    return cities;
  }
}
```

The `CityService` is a straightforward class with a single property and two methods. Currently, there is no need to
indicate that the class should be injectable.

Now that we have a service class to retrieve cities, let's use it inside the `CityController`:

```dart
@Controller('cities')
class CityController {
  final CityService _cityService;

  CityController(this._cityService);

  @Post()
  void create(@Body() City city) {
    _cityService.create(city);
  }

  @Get()
  List<City> findAll() {
    return _cityService.findAll();
  }
}
```

The `CityService` is injected through the class constructor.

# Provider registration

Now that we have defined a provider (`CityService`), and we have a consumer of that service (`CityController`), we
need to
register the service with Dartness so that it can perform the injection. We do this by editing our module file (
app.dart) and adding the service to the `providers` attribute of the `@Application()` annotation using
the `ModuleMetadata` class in order to structure the metadata and the  `ProviderMetadata` class to structure our
provider.

```dart
@Application(
  module: Module(
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
  ),
)
class App {}
```

Dartness will now be able to resolve the dependencies of the `CityController` class.

