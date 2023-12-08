import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class ConflictException extends HttpClientErrorException {
  const ConflictException(String message) : super(message, HttpStatus.conflict);
}
