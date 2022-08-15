// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension CityControllerRoutes on CityController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('GET', '/cities', getCities));
    routes.add(ControllerRoute('GET', '/cities/<id>', getCity));
    return routes;
  }
}
