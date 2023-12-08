import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class UnprocessableEntityException extends HttpClientErrorException {
  const UnprocessableEntityException(String message)
      : super(message, HttpStatus.unsupportedMediaType);
}
