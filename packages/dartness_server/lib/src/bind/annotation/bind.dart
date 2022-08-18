/// Annotation for a bindable property.
abstract class Bind {
  const Bind(this.method, [this.path = '']);

  /// The path to bind the property to.
  /// If not set, the entire route would be by [Controller].
  final String path;

  /// The method to bind the property to.
  final String method;

}
