import 'dart:io';

import 'http_server_error_exception.dart';

class ServiceUnavailableException extends HttpServerErrorException {
  const ServiceUnavailableException(String message)
      : super(message, HttpStatus.serviceUnavailable);
}
