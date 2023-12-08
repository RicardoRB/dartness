import 'dart:io';

import 'http_server_error_exception.dart';

class NotImplementedException extends HttpServerErrorException {
  const NotImplementedException(String message)
      : super(message, HttpStatus.notImplemented);
}
