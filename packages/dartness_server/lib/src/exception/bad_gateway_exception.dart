import 'dart:io';

import 'http_server_error_exception.dart';

/// A custom exception representing a "Bad Gateway" error (HTTP 502).
///
/// This exception extends [HttpServerErrorException] and is thrown to indicate
/// that the server, while acting as a gateway or proxy, received an invalid
/// response from an inbound server. It includes a human-readable [message] and
/// has an HTTP status code of [HttpStatus.badGateway].
class BadGatewayException extends HttpServerErrorException {
  /// Creates a [BadGatewayException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the bad gateway error.
  const BadGatewayException(String message)
      : super(message, HttpStatus.badGateway);
}
