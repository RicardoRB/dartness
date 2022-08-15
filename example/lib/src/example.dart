import 'package:dartness_server/dartness.dart';
import 'package:example/src/controllers/city_controller.dart';
import 'package:example/src/services/city_service.dart';

void main(List<String> args) async {
  final controllers = [
    CityController(CityService()),
  ];
  final app = Dartness(
    port: 3000,
    controllers: controllers.map(
        (controller) => DartnessController(controller, controller.getRoutes())),
  );
  app.create();
}
