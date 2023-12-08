import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class NotAcceptableException extends HttpClientErrorException {
  const NotAcceptableException(String message)
      : super(message, HttpStatus.notAcceptable);
}
