/// Annotation to mark a method that is handling the [errors].
///
/// Example:
/// ```dart
///   @CatchError([NotFoundException])
///   void handleNotFoundException(NotFoundException exception) {
///     print("Not found");
///   }
/// ```
class CatchError {
  const CatchError(this.errors);

  /// The [errors] that are handled by the [CatchError].
  final List<Type> errors;
}
