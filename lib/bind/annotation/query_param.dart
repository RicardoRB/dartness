/// Annotation to bind a property to a query parameter.
class QueryParam {
  const QueryParam([this.name]);

  /// The name of the variable parameter.
  /// If not set, the property name will be used.
  final String? name;
}
