import 'dart:io';

import 'http_server_error_exception.dart';

class GatewayTimeoutException extends HttpServerErrorException {
  const GatewayTimeoutException(String message)
      : super(message, HttpStatus.gatewayTimeout);
}
