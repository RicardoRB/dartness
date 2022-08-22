// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension GetControllerClassRoutes on GetControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
        'GET', '/get/custom_exception', getCustomException, [],
        httpCode: null, headers: {}));
    return routes;
  }
}

class GetDartnessControllerClass extends DartnessController {
  GetDartnessControllerClass(GetControllerClass controller)
      : super(controller, controller.getRoutes());
}
