// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension HealthControllerRoutes on HealthController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/health',
      handler: getAlive,
      params: [],
      httpCode: 202,
      headers: {'content-type': 'application/json'},
    ));
    return routes;
  }
}

class HealthDartnessController extends DartnessController {
  HealthDartnessController(HealthController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
