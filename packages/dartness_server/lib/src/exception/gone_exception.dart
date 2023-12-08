import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

class GoneException extends HttpClientErrorException {
  const GoneException(String message) : super(message, HttpStatus.gone);
}
