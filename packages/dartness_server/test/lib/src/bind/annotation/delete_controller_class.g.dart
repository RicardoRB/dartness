// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension DeleteControllerClassRoutes on DeleteControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/delete/double',
      handler: deleteDouble,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/delete/null',
      handler: deleteNull,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/delete/class',
      handler: deleteClass,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/delete/future',
      handler: deleteFuture,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'DELETE',
      path: '/delete/ids/<id>',
      handler: deleteParam,
      params: [
        DartnessParam(
          name: 'id',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        )
      ],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class DeleteDartnessControllerClass extends DartnessController {
  DeleteDartnessControllerClass(DeleteControllerClass controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
