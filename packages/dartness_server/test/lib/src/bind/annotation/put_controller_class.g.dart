// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension PutControllerClassRoutes on PutControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/put/double',
      handler: putDouble,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/put/null',
      handler: putNull,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/put/class',
      handler: putClass,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/put/future',
      handler: putFuture,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'PUT',
      path: '/put/ids/<id>',
      handler: putParam,
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

class PutDartnessControllerClass extends DartnessController {
  PutDartnessControllerClass(PutControllerClass controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
