class ControllerRoute {
  const ControllerRoute(this.method, this.path, this.handler);

  final String path;
  final String method;
  final Function handler;
}
