import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Not Acceptable" error (HTTP 406).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the server cannot produce a response matching the list of acceptable
/// values defined in the request's headers. It includes a human-readable [message]
/// and has an HTTP status code of [HttpStatus.notAcceptable].
class NotAcceptableException extends HttpClientErrorException {
  /// Creates a [NotAcceptableException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the not acceptable error.
  const NotAcceptableException(String message)
      : super(message, HttpStatus.notAcceptable);
}
