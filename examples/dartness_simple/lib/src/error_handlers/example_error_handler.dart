import 'package:dartness_server/exception.dart';
import 'package:example/src/error_handlers/not_found_exception.dart';

part 'example_error_handler.g.dart';

@ErrorHandler()
class ExampleErrorHandler {
  @CatchError([NotFoundException])
  void handleNotFoundException(final NotFoundException exception) {
    print("Not found exception found $exception");
  }
}
