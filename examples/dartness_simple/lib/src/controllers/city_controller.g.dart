// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension CityControllerRoutes on CityController {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/cities',
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
          defaultValue: '100',
          fromJson: null,
        )
      ],
      httpCode: 202,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'GET',
      path: '/cities/<id>',
      handler: getCity,
      params: [
        DartnessParam(
          name: 'id',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        )
      ],
      httpCode: null,
      headers: {'content-type': 'application/json'},
    ));
    return routes;
  }
}

class CityDartnessController extends DartnessController {
  CityDartnessController(CityController controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
