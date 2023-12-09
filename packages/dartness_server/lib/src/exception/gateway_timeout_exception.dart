import 'dart:io';

import 'http_server_error_exception.dart';

/// A custom exception representing a "Gateway Timeout" error (HTTP 504).
///
/// This exception extends [HttpServerErrorException] and is thrown to indicate
/// that the server, while acting as a gateway or proxy, did not receive a timely
/// response from an upstream server or some other auxiliary server. It includes
/// a human-readable [message] and has an HTTP status code of [HttpStatus.gatewayTimeout].
class GatewayTimeoutException extends HttpServerErrorException {
  /// Creates a [GatewayTimeoutException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the gateway timeout error.
  const GatewayTimeoutException(String message)
      : super(message, HttpStatus.gatewayTimeout);
}
