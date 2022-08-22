// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension TestControllerRoutes on TestController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(
        ControllerRoute('GET', '/auth', get, [], httpCode: null, headers: {}));
    routes.add(ControllerRoute('GET', '/auth/error', getError, [],
        httpCode: null, headers: {}));
    return routes;
  }
}
