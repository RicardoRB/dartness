/// Exception for HTTP status code.
/// This abstract class is used to create custom exceptions for HTTP status codes.
///
///
/// Example:
/// ```dart
/// class NotFoundException extends HttpStatusException {
///    const NotFoundException(String message) : super(message, HttpStatus.notFound);
/// }
/// ```
abstract class HttpStatusException implements Exception {
  const HttpStatusException(this.message, this.statusCode);

  /// The message of the exception.
  final String message;

  /// The http status code of the exception.
  final int statusCode;
}
