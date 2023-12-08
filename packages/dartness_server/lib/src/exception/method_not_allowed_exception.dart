import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class MethodNotAllowedException extends HttpClientErrorException {
  const MethodNotAllowedException(String message)
      : super(message, HttpStatus.methodNotAllowed);
}
