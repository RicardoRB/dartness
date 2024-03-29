import 'dart:io';

import 'package:dartness_server/exception.dart';
import 'package:dartness_server/server.dart';

part 'custom_error_handler.g.dart';

@ErrorHandler()
class CustomErrorHandler {
  static final CustomErrorHandler instance = CustomErrorHandler();

  @CatchError([ArgumentError])
  DartnessResponse argumentErrorHandler(
      ArgumentError error, DartnessRequest request) {
    return DartnessResponse(
      statusCode: HttpStatus.badRequest,
      body: 'ArgumentError',
    );
  }

  @CatchError([RangeError])
  void rangeErrorHandler(RangeError error, DartnessRequest request) {
    print('RangeError');
  }
}
