# Custom providers

Custom providers typically refer to services or objects that you create and configure yourself to be used within your
application. These providers are not part of the core `Dartness` framework or provided by any third-party libraries;
instead, you define them to suit your specific needs. Custom providers can include services, repositories, factories, or
any other objects that your application requires for its functionality.

Custom providers are an essential part of the Dartness dependency injection system, which allows you to manage and
inject dependencies throughout your application. By creating custom providers, you can decouple various parts of your
application and make it more modular and maintainable.

## Standard providers

Let's take a closer look at the `ModuleMetadata` class. In `app.dart`, we declare in our section [providers]:

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

The providers attribute takes an array of providers. We've supplied those providers via a list of `ProviderMetadata`
class that we can specify by the attribute `classType` the class that we want to have as provider.

## Custom providers

What happens when your requirements go beyond those offered by Standard providers? Here are a few examples.

### Factory providers

The `useFactory` syntax allows for creating providers dynamically. The actual provider will be supplied by the value
returned from a factory function. The factory function can be as simple or complex as needed. A simple factory may not
depend on any other providers. A more complex factory can itself inject other providers it needs to compute its result.
For the latter case, the factory provider syntax has a pair of related mechanisms:

```dart

Dio createDio() => Dio();

CityService createCityService(Dio dio) => CityService(dio);

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
          classType: Dio,
          useFactory: createDio,
        ),
        ProviderMetadata(
          classType: CityService,
          useFactory: createCityService,
        ),
      ],
    ),
  ),
)
class App {}
```

> **_NOTE:_**  As current limitations of `dart` language, it is not allow to use `const` `Function` as part of the
> attribute, in order to avoid it you need to declare the `Function` as global as we saw in the previous example.

**BAD!!!**

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
          classType: Dio,
          // this is not going to work
          useFactory: () => Dio(),
        ),
        ProviderMetadata(
          classType: CityService,
          // this is not going to work
          useFactory: (Dio dio) => CityService(dio),
        ),
      ],
    ),
  ),
)
class App {}
```