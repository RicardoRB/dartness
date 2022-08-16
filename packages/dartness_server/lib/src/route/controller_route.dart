class ControllerRoute {
  const ControllerRoute(
    this.method,
    this.path,
    this.handler,
    this.positionalArguments,
    this.namedArguments,
  );

  final String path;
  final String method;
  final Function handler;
  final List<String> positionalArguments;
  final Map<String, dynamic>? namedArguments;
}
