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
  void handle(Request request) {
    // do something before the request is executed
    request.headers[HttpHeaders.authorizationHeader] = 'token';
  }
}
```

## Applying middleware

In order to apply your middleware, you need to add it to the `middleware` list in the `DartnessServer` class.

```dart
void main() async {
  final app = Dartness(
    port: 3000,
    middlewares: [MyMiddleware()],
  );
  // As optional, you can also use app.addMiddleware(MyMiddleware());
  await app.create();
}
```