# Middleware

Middleware is a class which is called before the route handler. Middleware classes have access to the request
objects. The middleware class can modify the request object.

Middleware classes can be used like the following task:

- execute any code before executing the request.
- make changes to the request.

You implement custom Dartness middleware in a class. The class should implement the DartnessMiddleware abstract class.
Below you can find an example implementation to a simple middleware feature using the class method.

```dart
class MyMiddleware implements DartnessMiddleware {
  @override
  void handle(DartnessRequest request) {
    // do something before the request is executed
    request.headers[HttpHeaders.authorizationHeader] = 'token';
  }
}
```

## Applying middleware

In order to apply your middleware, you need to add it to the `middleware` list in the `Module` annotation.

```dart
@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [],
      providers: [
        ProviderMetadata(
          classType: MyMiddleWare,
        ),
      ],
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