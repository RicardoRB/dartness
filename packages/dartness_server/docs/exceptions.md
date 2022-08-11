# Exceptions

Exception is a class that is used to represent an error condition, it is usually used to change your business logic
or response in your API.

Dartness provides different ways to handle or throw exceptions.

## HttpStatusException

HttpStatusException is a class that is extended from Exception class and is used to throw an exception with a specific
HTTP status code. Use this class to throw an exception when you want to return a specific HTTP status code. If the
exception thrown is not handled by the client, the default status code is 500. You can find and example below:

```dart
class NotFoundException extends HttpStatusException {
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
```

## Global ErrorHandler

Dartness provides with a built-in exceptions layer which is responsible for processing all unhandled exceptions across
an
application. When an exception is not handled by your application code, it is caught by this layer, which allow you to
create a logic when an exception occurs including returning a specific response.

An error handle is any kind of class that implements a `static` method that is annotated with `@CatchError`. This method
will handle the corresponding exception or exceptions that you want to catch.

You can find an example below:

#### One exception

```dart
class ErrorHandler {

  @CatchError([NotFoundException])
  Response handleNotFoundException(NotFoundException error) {
    return Response.notFound(error.message);
  }

}
```

#### Multiple exceptions

```dart 
class ErrorHandler {

  @CatchError([ForbiddenException, UnauthorizedException])
  Response handleMultipleException(Exception error) {
    return Response.unauthorized(error.message);
  }

}
```

> **_NOTE:_** `@CatchError` accept multiple errors as a list parameter, in order to get the specific error as parameter,
> you need to just specify only 1 error. Otherwise, the error parameter should be a parent of them. Usually, `Error` or
> `Exception`.

### Adding Error Handler to your application

Dartness accept multiple error handling layers, you can add your own error handling layer to your application by
send them to the `addErrorHandler` method or by name parameter.

```dart
void main() async {
  final app = Dartness(
      port: 3000,
      errorHandlers: [ErrorHandler()]
  );
  // As optional, you can also use app.addErrorHandler(ErrorHandler());
  // app.addErrorHandler(ErrorHandler());
  await app.create();
}
```