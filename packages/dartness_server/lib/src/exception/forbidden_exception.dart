import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Forbidden" error (HTTP 403).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the server understood the request, but it refuses to authorize it.
/// It includes a human-readable [message] and has an HTTP status code of
/// [HttpStatus.forbidden].
class ForbiddenException extends HttpClientErrorException {
  /// Creates a [ForbiddenException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the forbidden error.
  const ForbiddenException(String message)
      : super(message, HttpStatus.forbidden);
}
