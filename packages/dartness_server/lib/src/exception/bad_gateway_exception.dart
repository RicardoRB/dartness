import 'dart:io';

import 'http_server_error_exception.dart';

class BadGatewayException extends HttpServerErrorException {
  const BadGatewayException(String message)
      : super(message, HttpStatus.badGateway);
}
