import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class UnauthorizedException extends HttpClientErrorException {
  const UnauthorizedException(String message)
      : super(message, HttpStatus.unauthorized);
}
