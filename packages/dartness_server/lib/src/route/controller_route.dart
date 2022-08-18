import 'package:dartness_server/dartness.dart';

/// The data required to handle the class annotated with [Controller]
/// internally by the Dartness framework.
class ControllerRoute {
  const ControllerRoute(
    this.method,
    this.path,
    this.handler,
    this.params, {
    this.httpCode,
    this.headers,
  });

  /// The path of the route.
  final String path;

  /// The http method name of the route.
  final String method;

  /// The function to be called when executing the route.
  final Function handler;

  /// The params of the route.
  final List<DartnessParam> params;

  /// The http code of the route if indicated.
  final int? httpCode;

  /// The headers of the route if indicated.
  final Map<String, String>? headers;
}
