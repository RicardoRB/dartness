import 'package:dartness_server/exception.dart';

/// Custom exception class representing HTTP client errors.
///
/// This class extends [HttpStatusCodeException] and is used to indicate errors
/// that occur on the client side of an HTTP request. It includes a human-readable
/// [message] describing the error and an associated HTTP [statusCode].
class HttpClientErrorException extends HttpStatusCodeException {
  /// Creates an instance of [HttpClientErrorException] with the specified [message]
  /// and HTTP [statusCode].
  const HttpClientErrorException(super.message, super.statusCode);
}
