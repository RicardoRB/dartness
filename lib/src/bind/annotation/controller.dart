/// Annotation to identify a class as a controller.
/// A controller is a class that can be used to handle requests.
///
/// The controller class can handle requests by implementing the
/// methods and annotated with [Get], [Post], [Put], [Delete].
///
/// Example:
/// ```dart
/// @Controller('/')
/// class ExampleController {
///   @Get()
///   String get() {
///     return 'Hello World!';
///   }
///  }
///  ```
class Controller {
  const Controller(this.path);

  final String path;
}
