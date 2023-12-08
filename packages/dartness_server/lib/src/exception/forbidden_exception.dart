import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class ForbiddenException extends HttpClientErrorException {
  const ForbiddenException(String message)
      : super(message, HttpStatus.forbidden);
}
