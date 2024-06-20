import 'package:dartness_server/exception.dart';

part 'example_error_handler.g.dart';

@ErrorHandler()
class ExampleErrorHandler {
  @CatchError([NotFoundException])
  void handleNotFoundException(final NotFoundException exception) {
    print("Not found exception found $exception");
  }
}
