import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Method Not Allowed" error (HTTP 405).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the HTTP method used on a resource is not supported. It includes a
/// human-readable [message] and has an HTTP status code of [HttpStatus.methodNotAllowed].
class MethodNotAllowedException extends HttpClientErrorException {
  /// Creates a [MethodNotAllowedException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the method not allowed error.
  const MethodNotAllowedException(String message)
      : super(message, HttpStatus.methodNotAllowed);
}
