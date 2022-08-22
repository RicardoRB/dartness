// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension GetControllerClassRoutes on GetControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('GET', '/get/double', getDouble, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('GET', '/get/null', getNull, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('GET', '/get/class', getClass, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('GET', '/get/future', getFuture, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/ids/<id>',
        getParam,
        [
          DartnessParam('id', false, true, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/query',
        getQuery,
        [
          DartnessParam('id', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/queries',
        getQueries,
        [
          DartnessParam('id', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam('id2', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/paths/<id>',
        getPaths,
        [
          DartnessParam('id', false, true, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam('query', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/paths/<path1>/another/<path2>',
        getPathsAnotherPaths,
        [
          DartnessParam('path1', false, true, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam('query', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam('path2', false, true, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam('query2', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/types',
        getTypes,
        [
          DartnessParam('bool', true, false, false, false, true, false, bool,
              defaultValue: null, fromJson: null),
          DartnessParam('int', true, false, false, false, true, false, int,
              defaultValue: null, fromJson: null),
          DartnessParam(
              'double', true, false, false, false, true, false, double,
              defaultValue: null, fromJson: null),
          DartnessParam(
              'string', true, false, false, false, true, false, String,
              defaultValue: null, fromJson: null),
          DartnessParam(
              'list', true, false, false, false, true, false, List<int>,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/optional',
        getOptional,
        [
          DartnessParam('bool', true, false, false, false, true, false, bool,
              defaultValue: null, fromJson: null),
          DartnessParam('int', true, false, false, true, false, true, int,
              defaultValue: '1', fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'GET',
        '/get/names/<namePath>',
        getNames,
        [
          DartnessParam(
              'namePath', false, true, false, false, true, false, String,
              defaultValue: null, fromJson: null),
          DartnessParam(
              'nameQuery', true, false, false, false, true, false, String,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute('GET', '/get/statuscodes', getStatusCode, [],
        httpCode: 202, headers: {}));
    routes.add(ControllerRoute('GET', '/get/headers', getHeader, [],
        httpCode: null, headers: {'test': 'test'}));
    return routes;
  }
}
