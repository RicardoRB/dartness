// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hello_world_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension ExampleControllerRoutes on ExampleController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/hello/world',
      handler: getHelloWorld,
      params: [],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class ExampleDartnessController extends DartnessController {
  ExampleDartnessController(ExampleController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
