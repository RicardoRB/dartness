/// Annotation to bind a property to a request query.
class QueryParam {
  const QueryParam([this.name]);

  /// The name of the variable parameter.
  /// If not set, the property name will be used.
  final String? name;
}
