# Interceptor

Interceptor is a class which is called before and after the route handler. Interceptor class have access to the request
and response objects also you can access the error and stacktrace if an error happens meanwhile executing
the request.

Interceptor classes can be used like the following task:

- bind extra logic before / after request execution
- transform the response from a request
- transform the exception thrown from a request
- extend the basic function behavior
- completely override a function depending on specific conditions (e.g., for caching purposes)
- add custom headers to the response
- add custom headers to the request
- add some logic when an exception happens

You implement custom Dartness middleware in a class. The class should implement the DartnessMiddleware abstract class.
Below you can find an example implementation to a simple middleware feature using the class method.

```dart
class MyInterceptor implements DartnessInterceptor {
  @override
  void onRequest(DartnessRequest request) {
    // do something before the request is executed
  }

  @override
  void onResponse(DartnessResponse response) {
    // do something after the request is executed
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // do something when an error happens
  }
}
```

## Applying interceptor

In order to apply your interceptor, you need to add it to the `interpcetors` list in the `Module` annotation. This
will create a global interceptors and are used across the whole application, for every controller and every route
handler.

```dart
@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [],
      providers: [
        ProviderMetadata(
          classType: MyInterceptor,
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