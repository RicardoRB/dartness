import 'dart:io';

import 'http_server_error_exception.dart';

/// A custom exception representing a "Service Unavailable" error (HTTP 503).
///
/// This exception extends [HttpServerErrorException] and is thrown to indicate
/// that the server is currently unable to handle the request. It includes a
/// human-readable [message] and has an HTTP status code of [HttpStatus.serviceUnavailable].
class ServiceUnavailableException extends HttpServerErrorException {
  /// Creates a [ServiceUnavailableException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the service unavailable error.
  const ServiceUnavailableException(String message)
      : super(message, HttpStatus.serviceUnavailable);
}
