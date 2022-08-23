/// Annotation to bind a property to a path parameter.
class PathParam {
  const PathParam([this.name]);

  /// The name of the variable parameter.
  /// If not set, the property name will be used.
  final String? name;
}
