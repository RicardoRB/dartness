// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension CityControllerRoutes on CityController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute('GET', '/cities', getCities, [
      DartnessParam('offset', true, false, true, false, true,
          defaultValue: null)
    ]));
    routes.add(ControllerRoute('GET', '/cities/<id>', getCity, [
      DartnessParam('id', false, true, false, true, false, defaultValue: null)
    ]));
    return routes;
  }
}
