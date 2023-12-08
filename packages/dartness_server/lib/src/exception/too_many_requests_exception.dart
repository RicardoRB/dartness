import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class TooManyRequestsException extends HttpClientErrorException {
  const TooManyRequestsException(String message)
      : super(message, HttpStatus.tooManyRequests);
}
