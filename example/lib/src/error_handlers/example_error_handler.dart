import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/exception.dart';
import 'package:example/src/error_handlers/not_found_exception.dart';

part 'example_error_handler.g.dart';

@ErrorHandler()
class ExampleErrorHandler {
  @CatchError([NotFoundException])
  DartnessResponse handleNotFoundException(final NotFoundException exception) {
    print("Not found exception found $exception");
    return DartnessResponse(
      statusCode: HttpStatus.notFound,
      body: exception.message,
    );
  }
}
