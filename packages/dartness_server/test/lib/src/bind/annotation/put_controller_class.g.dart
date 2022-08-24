// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension PutControllerClassRoutes on PutControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('PUT', '/put/double', putDouble, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('PUT', '/put/null', putNull, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('PUT', '/put/class', putClass, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute('PUT', '/put/future', putFuture, [],
        httpCode: null, headers: {}));
    routes.add(ControllerRoute(
        'PUT',
        '/put/ids/<id>',
        putParam,
        [
          DartnessParam('id', false, true, false, false, true, false, int,
              defaultValue: null, fromJson: null)
        ],
        httpCode: null,
        headers: {}));
    return routes;
  }
}

class PutDartnessControllerClass extends DartnessController {
  PutDartnessControllerClass(PutControllerClass controller)
      : super(controller, controller.getRoutes());
}
