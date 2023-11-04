# Providers

Providers refer to a core concept related to dependency injection. Providers are responsible for creating and managing
various dependencies and services that your application needs. These dependencies can include things like services,
repositories, configuration settings, database connections, and more. Dartness uses providers as a fundamental building
block for organizing and maintaining the components of your application.

## Services

To begin, we can create a basic `CitiesService` that will handle data storage and retrieval. This service is intended to
be utilized by the `CitiesController` and is a suitable candidate for registration as a provider.

```dart
class CitiesService {
  final List<City> cities = [];

  void create(City city) {
    cities.add(city);
  }

  List<City> findAll() {
    return cities;
  }
}
```

The `CitiesService` is a straightforward class with a single property and two methods. Currently, there is no need to
indicate that the class should be injectable.

Now that we have a service class to retrieve cities, let's use it inside the `CitiesController`:

```dart
@Controller('cities')
class CatsController {
  final CitiesService _citiesService;

  CatsController(this._citiesService);

  @Post()
  void create(@Body() City city) {
    catsService.create(city);
  }

  @Get()
  List<City> findAll() {
    return catsService.findAll();
  }
}
```

The `CitiesService` is injected through the class constructor.

# Provider registration

Now that we have defined a provider (`CitiesService`), and we have a consumer of that service (`CitiesController`), we
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
          classType: CitiesController,
        ),
      ],
      providers: [
        ProviderMetadata(
          classType: CitiesService,
        ),
      ],
    ),
  ),
)
class App {}
```

Dartness will now be able to resolve the dependencies of the `CitiesController` class.

