import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Conflict" error (HTTP 409).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the request could not be completed due to a conflict with the current
/// state of the target resource. It includes a human-readable [message] and
/// has an HTTP status code of [HttpStatus.conflict].
class ConflictException extends HttpClientErrorException {
  /// Creates a [ConflictException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the conflict error.
  const ConflictException(String message) : super(message, HttpStatus.conflict);
}
