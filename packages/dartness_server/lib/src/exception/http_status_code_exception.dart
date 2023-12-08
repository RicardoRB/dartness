/// Exception for HTTP status code.
/// This abstract class is used to create custom exceptions for HTTP status codes.
///
///
/// Example:
/// ```dart
/// class NotFoundException extends HttpStatusCodeException {
///    const NotFoundException(String message) : super(message, HttpStatus.notFound);
/// }
/// ```
abstract class HttpStatusCodeException implements Exception {
  const HttpStatusCodeException(this.message, this.statusCode);

  /// The message of the exception.
  final String message;

  /// The http status code of the exception.
  final int statusCode;
}
