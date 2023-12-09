import 'package:dartness_server/exception.dart';

/// A custom exception representing a generic HTTP server error.
///
/// This exception extends [HttpStatusCodeException] and is used to signal
/// errors that occur on the server side. It includes a human-readable [message]
/// and an associated HTTP [statusCode] indicating the nature of the server error.
class HttpServerErrorException extends HttpStatusCodeException {
  /// Creates an [HttpServerErrorException] with the specified [message] and [statusCode].
  ///
  /// The [message] is a human-readable description of the server error, and
  /// [statusCode] represents the HTTP status code associated with the error.
  const HttpServerErrorException(super.message, super.statusCode);
}
