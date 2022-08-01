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

  final String message;
  final int statusCode;
}
