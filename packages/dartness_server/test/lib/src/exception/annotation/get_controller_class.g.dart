// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension GetControllerClassRoutes on GetControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
        'GET', '/get/argument_error', getArgumentException, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('GET', '/get/range_error', getRangeError, [],
        httpCode: null, headers: {}));
    return routes;
  }
}
