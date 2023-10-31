// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension UserControllerRoutes on UserController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/users',
      handler: getCities,
      params: [
        DartnessParam(
          name: 'offset',
          isQuery: true,
          isPath: false,
          isBody: false,
          isNamed: true,
          isPositional: false,
          isOptional: true,
          type: int,
          defaultValue: null,
          fromJson: null,
        )
      ],
      httpCode: 202,
      headers: {'content-type': 'application/json'},
    ));
    return routes;
  }
}

class UserDartnessController extends DartnessController {
  UserDartnessController(UserController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
