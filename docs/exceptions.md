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

### Code generation

Error handlers use the code generation mechanism in order to provide reflection possible thanks to
the [Dart Build System](https://github.com/dart-lang/build). This means that when generating the code the error handlers
will have two parts, one done by the developer and other one automatically generated by `dartness_generator`.

Once you have added the annotations and added the corresponding `part '*.g.dart';` to your code you then need to run the
code generator to generate the
missing `.g.dart` generated dart files.

Run `dart run build_runner build` in the package directory to generate the missing parts.

Dartness provides with a built-in exceptions layer which is responsible for processing all unhandled exceptions across
an
application. When an exception is not handled by your application code, it is caught by this layer, which allow you to
create a logic when an exception occurs including returning a specific response.

An error handle is any kind of class that is annotated with `@ErrorHandler` and implements one or more methods that is
annotated with `@CatchError`. This method will handle the corresponding exception or exceptions that you want to catch.

You can find an example below:

#### One exception

```dart
part 'error_handler.g.dart';

@ErrorHandler()
class ErrorHandler {

  @CatchError([NotFoundException])
  DartnessResponse handleNotFoundException(NotFoundException error) {
    return Response.notFound(error.message);
  }

}
```

#### Multiple exceptions

```dart 

part 'error_handler.g.dart';

@ErrorHandler()
class ErrorHandler {

  @CatchError([ForbiddenException, UnauthorizedException])
  DartnessResponse handleMultipleException(Exception error) {
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

After that you execute `dart run build_runner build`, a new class will be generated that extends
from `DartnessErrorHandler`, the name of this class will be the name of your class + 'DartnessErrorHandler' appended
replacing 'ErrorHandler' to 'DartnessErrorHandler', if the name of your class contains it, for example for `GeneralErrorHandler`
a class called `GeneralDartnessErrorHandler` will be generated. If your class doesn't contain 'ErrorHandler' in the name, '
DartnessErrorHandler' will append to the name, for example for `AwesomeClass` a class
called `AwesomeClassDartnessErrorHandler` will be created.

This new created class accepts an instance of the class from where have been created as param in the constructor, and it
must be used in the `errorHandlers` param. You can see an example in the following code:

```dart

@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [],
      providers: [
        ProviderMetadata(
          classType: MyException,
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