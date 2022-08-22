// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension DeleteControllerClassRoutes on DeleteControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('DELETE', '/delete/double', deleteDouble, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('DELETE', '/delete/null', deleteNull, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('DELETE', '/delete/class', deleteClass, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('DELETE', '/delete/future', deleteFuture, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute(
        'DELETE',
        '/delete/ids/<id>',
        deleteParam,
        [
          DartnessParam('id', false, false, false, true, false, int,
              defaultValue: null)
        ],
        httpCode: null,
        headers: {}));
    return routes;
  }
}
