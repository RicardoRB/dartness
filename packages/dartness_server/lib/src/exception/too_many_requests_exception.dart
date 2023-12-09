import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Too Many Requests" error (HTTP 429).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the client has sent too many requests in a given amount of time. It
/// includes a human-readable [message] and has an HTTP status code of
/// [HttpStatus.tooManyRequests].
class TooManyRequestsException extends HttpClientErrorException {
  /// Creates a [TooManyRequestsException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the too many requests error.
  const TooManyRequestsException(String message)
      : super(message, HttpStatus.tooManyRequests);
}
