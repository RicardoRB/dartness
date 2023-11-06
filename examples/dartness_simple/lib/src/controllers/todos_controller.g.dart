// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension TodosControllerRoutes on TodosController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/todos',
      handler: getAlive,
      params: [],
      httpCode: null,
      headers: {'content-type': 'application/json'},
    ));
    return routes;
  }
}

class TodosDartnessController extends DartnessController {
  TodosDartnessController(TodosController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
