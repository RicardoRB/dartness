import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing an "Unauthorized" error (HTTP 401).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the request has not been applied because it lacks valid authentication
/// credentials for the target resource. It includes a human-readable [message]
/// and has an HTTP status code of [HttpStatus.unauthorized].
class UnauthorizedException extends HttpClientErrorException {
  /// Creates an [UnauthorizedException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the unauthorized error.
  const UnauthorizedException(String message)
      : super(message, HttpStatus.unauthorized);
}
