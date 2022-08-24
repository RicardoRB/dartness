import 'controller_route.dart';

/// A wrapper class in order to retrieve the controller instance from the
/// annotation [Controller] and the data required to handle it internally by the
/// Dartness framework.
class DartnessController {
  const DartnessController(this.controller, this.routes);

  /// The controller instance.
  final Object controller;

  /// The routes that the controller can handle.
  final List<ControllerRoute> routes;
}
