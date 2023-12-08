import 'dart:io';

import 'http_client_error_exception.dart';

/// A custom exception representing a "Not Found" error.
///
/// This exception extends [HttpClientErrorException] and is typically thrown
/// when a requested resource or entity could not be found. It has a constant
/// HTTP status code [HttpStatus.notFound].
class NotFoundException extends HttpClientErrorException {
  /// Creates a [NotFoundException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the exception.
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
