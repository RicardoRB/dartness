/// Annotation for a bindable property.
abstract class Bind {
  const Bind([this.path = '']);

  /// The path to bind the property to.
  /// If not set, the entire route would be by [Controller].
  final String path;

  /// The name of the class in uppercase.
  @override
  String toString() {
    return runtimeType.toString().toUpperCase();
  }
}
