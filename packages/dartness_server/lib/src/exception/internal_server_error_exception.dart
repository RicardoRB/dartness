import 'dart:io';

import 'http_server_error_exception.dart';

class InternalServerErrorException extends HttpServerErrorException {
  const InternalServerErrorException(String message)
      : super(message, HttpStatus.internalServerError);
}
