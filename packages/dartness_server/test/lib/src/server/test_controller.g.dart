// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension TestControllerRoutes on TestController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/auth',
      handler: get,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/auth/error',
      handler: getError,
      params: [],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class TestDartnessController extends DartnessController {
  TestDartnessController(TestController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
