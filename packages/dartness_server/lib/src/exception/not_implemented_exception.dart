import 'dart:io';

import 'http_server_error_exception.dart';

/// A custom exception representing a "Not Implemented" error (HTTP 501).
///
/// This exception extends [HttpServerErrorException] and is thrown to indicate
/// that the server does not support the functionality required to fulfill
/// the request. It includes a human-readable [message] and has an HTTP status
/// code of [HttpStatus.notImplemented].
class NotImplementedException extends HttpServerErrorException {
  /// Creates a [NotImplementedException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the not implemented error.
  const NotImplementedException(String message)
      : super(message, HttpStatus.notImplemented);
}
