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