/// Annotation to mark a method that is handling the [errors].
///
/// Example:
/// ```dart
///   @CatchError([NotFoundException])
///   Response handleNotFoundException(Error error) {
///     return Response.notFound(error.message);
///   }
/// ```
class CatchError {
  const CatchError(this.errors);

  /// The [errors] that are handled by the [CatchError].
  final List<Type> errors;
}
