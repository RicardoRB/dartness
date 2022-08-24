// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension ClassControllerRoutes on ClassController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(
        ControllerRoute('GET', '/', getEmpty, [], httpCode: null, headers: {}));
    routes.add(ControllerRoute('POST', '/', postEmpty, [],
        httpCode: null, headers: {}));
    routes.add(
        ControllerRoute('PUT', '/', putEmpty, [], httpCode: null, headers: {}));
    routes.add(ControllerRoute('DELETE', '/', deleteEmpty, [],
        httpCode: null, headers: {}));
    return routes;
  }
}

class ClassDartnessController extends DartnessController {
  ClassDartnessController(ClassController controller)
      : super(controller, controller.getRoutes());
}
