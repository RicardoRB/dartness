// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension ClassControllerRoutes on ClassController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/',
      handler: getEmpty,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/',
      handler: postEmpty,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/',
      handler: putEmpty,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/',
      handler: deleteEmpty,
      params: [],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class ClassDartnessController extends DartnessController {
  ClassDartnessController(ClassController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
