import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class BadRequestException extends HttpClientErrorException {
  const BadRequestException(String message)
      : super(message, HttpStatus.badRequest);
}
