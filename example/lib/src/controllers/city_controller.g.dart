// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_controller.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension $CityControllerRouter on CityController {
  DefaultDartnessRouter getRouter() {
    final router = DefaultDartnessRouter();
    router.add('GET', '', DartnessRouterHandler(this.getCities));
    router.add('GET', '/:id', DartnessRouterHandler(this.getCity));
    return router;
  }
}
