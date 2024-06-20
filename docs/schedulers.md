# Schedulers

Schedulers enables you to set arbitrary code (methods/functions) to run at a specific date and time, at regular intervals, or once after a certain duration. In the Linux environment, this is typically managed by packages such as cron at the operating system level. For Node.js applications, various packages offer cron-like functionality. Dartness offers the `@Scheduler` annotation, which works with the cron package https://pub.dev/packages/cron. This chapter will discuss this scheduling in detail.

## Declarative cron jobs

A cron job automatically schedules an arbitrary function (method call) to run. Cron jobs can be configured to:

1. Run once at a specified date and time.
2. Run on a recurring basis, at specified intervals (for example, once per hour, once per week, once every 5 minutes).

To declare a cron job, use the @Cron() decorator before the method definition containing the code to be executed, as shown below:

```dart
import 'package:dartness_server/schedule.dart';

part 'example_scheduler.g.dart';

@Scheduler()
class ExampleScheduler {
  @Scheduled(cron: "* * * * *")
  void example() {
    print("${DateTime.now()} Hello world");
  }
}
```

In this example, the method `example()` will be called every second. As you can see, the class is annotated with `@Scheduler` to indicate that the class contains scheduler tasks and every method that needs to be scheduled is annotated with `@Scheduled` accepting as a param a cron.

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

