/// An abstract base class for custom exceptions representing HTTP status code errors.
///
/// This class extends [Exception] and serves as a foundation for creating specific
/// exceptions related to HTTP status codes. It includes a human-readable [message]
/// describing the error and an associated HTTP [statusCode].
abstract class HttpStatusCodeException implements Exception {
  /// Creates an instance of [HttpStatusCodeException] with the specified [message]
  /// and HTTP [statusCode].
  const HttpStatusCodeException(this.message, this.statusCode);

  /// A human-readable description of the exception.
  final String message;

  /// The HTTP status code associated with the exception.
  final int statusCode;
}
