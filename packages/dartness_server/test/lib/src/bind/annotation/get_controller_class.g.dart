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
      path: '/get/double',
      handler: getDouble,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/null',
      handler: getNull,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/class',
      handler: getClass,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/future',
      handler: getFuture,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/ids/<id>',
      handler: getParam,
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
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/query',
      handler: getQuery,
      params: [
        DartnessParam(
          name: 'id',
          isQuery: true,
          isPath: false,
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
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/queries',
      handler: getQueries,
      params: [
        DartnessParam(
          name: 'id',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'id2',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/paths/<id>',
      handler: getPaths,
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
        ),
        DartnessParam(
          name: 'query',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/paths/<path1>/another/<path2>',
      handler: getPathsAnotherPaths,
      params: [
        DartnessParam(
          name: 'path1',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'query',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'path2',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'query2',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/types',
      handler: getTypes,
      params: [
        DartnessParam(
          name: 'bool',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: bool,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'int',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'double',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: double,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'string',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: String,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'list',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: List<int>,
          defaultValue: null,
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/optional',
      handler: getOptional,
      params: [
        DartnessParam(
          name: 'bool',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: bool,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'int',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: true,
          isPositional: false,
          isOptional: true,
          type: int,
          defaultValue: '1',
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/names/<namePath>',
      handler: getNames,
      params: [
        DartnessParam(
          name: 'namePath',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: String,
          defaultValue: null,
          fromJson: null,
        ),
        DartnessParam(
          name: 'nameQuery',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: String,
          defaultValue: null,
          fromJson: null,
        ),
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/statuscodes',
      handler: getStatusCode,
      params: [],
      httpCode: 202,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/get/headers',
      handler: getHeader,
      params: [],
      httpCode: null,
      headers: {'test': 'test'},
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
