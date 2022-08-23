/// The param data from the route method required to handle the class
/// annotated with [Controller] internally by the Dartness framework.
class DartnessParam {
  DartnessParam(
    this.name,
    this.isQuery,
    this.isPath,
    this.isBody,
    this.isNamed,
    this.isPositional,
    this.isOptional,
    this.type, {
    this.defaultValue,
    this.fromJson,
  });

  /// The name of the param.
  final String name;

  /// Whether the param is a query param.
  final bool isQuery;

  /// Whether the param is a path param.
  final bool isPath;

  /// Whether the param is a body param.
  final bool isBody;

  /// Whether the param is a named param.
  final bool isNamed;

  /// Whether the param is a positional param.
  final bool isPositional;

  /// Whether the param is optional.
  final bool isOptional;

  /// The type of the param.
  final Type type;

  /// The default value of the param.
  final dynamic defaultValue;

  /// The function to convert the param from json.
  final Function? fromJson;
}
