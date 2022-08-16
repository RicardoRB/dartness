class DartnessParam {
  DartnessParam(
    this.name,
    this.isQuery,
    this.isPath,
    this.isNamed,
    this.isPositional,
    this.isOptional, {
    this.defaultValue,
  });

  final String name;
  final bool isQuery;
  final bool isPath;
  final bool isNamed;
  final bool isPositional;
  final bool isOptional;
  final dynamic defaultValue;
}
