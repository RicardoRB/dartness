import 'dart:io';

import 'http_server_error_exception.dart';

/// A custom exception representing an internal server error (HTTP 500).
///
/// This exception extends [HttpServerErrorException] and is specifically used
/// to indicate that an unexpected error occurred on the server side. It includes
/// a human-readable [message] and has an HTTP status code of [HttpStatus.internalServerError].
class InternalServerErrorException extends HttpServerErrorException {
  /// Creates an [InternalServerErrorException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the internal server error.
  const InternalServerErrorException(String message)
      : super(message, HttpStatus.internalServerError);
}
