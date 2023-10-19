// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension GetControllerClassRoutes on GetControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/argument_error',
      handler: getArgumentException,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/range_error',
      handler: getRangeError,
      params: [],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class GetDartnessControllerClass extends DartnessController {
  GetDartnessControllerClass(GetControllerClass controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
