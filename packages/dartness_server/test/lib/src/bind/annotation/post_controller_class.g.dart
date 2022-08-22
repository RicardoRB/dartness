// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension PostControllerClassRoutes on PostControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('POST', '/post/double', postDouble, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('POST', '/post/null', postNull, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('POST', '/post/class', postClass, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('POST', '/post/future', postFuture, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute(
        'POST',
        '/post/ids/<id>',
        postParam,
        [
          DartnessParam('id', false, true, false, true, false, int,
              defaultValue: null)
        ],
        httpCode: null,
        headers: {}));
    routes.add(ControllerRoute(
        'POST',
        '/post/body',
        postBody,
        [
          DartnessParam('body', false, false, false, true, false, Foo,
              defaultValue: null)
        ],
        httpCode: null,
        headers: {}));
    return routes;
  }
}
