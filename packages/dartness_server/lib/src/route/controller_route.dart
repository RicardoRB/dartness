import '../datness_param.dart';

class ControllerRoute {
  const ControllerRoute(
    this.method,
    this.path,
    this.handler,
    this.params, {
    this.httpCode,
  });

  final String path;
  final String method;
  final Function handler;
  final List<DartnessParam> params;
  final int? httpCode;
}
