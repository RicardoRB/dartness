// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension ExampleControllerRoutes on ExampleController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('GET', '/hello/world', getHelloWorld, [],
        httpCode: null, headers: {}));
    return routes;
  }
}

class ExampleDartnessController extends DartnessController {
  ExampleDartnessController(ExampleController controller)
      : super(controller, controller.getRoutes());
}
