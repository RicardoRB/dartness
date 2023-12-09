import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Bad Request" error (HTTP 400).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the server cannot or will not process the request due to something
/// that is perceived to be a client error. It includes a human-readable [message]
/// and has an HTTP status code of [HttpStatus.badRequest].
class BadRequestException extends HttpClientErrorException {
  /// Creates a [BadRequestException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the bad request error.
  const BadRequestException(String message)
      : super(message, HttpStatus.badRequest);
}
