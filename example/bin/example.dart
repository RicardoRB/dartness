import 'package:dartness_server/dartness.dart';
import 'package:example/src/controllers/city_controller.dart';
import 'package:example/src/error_handlers/example_error_handler.dart';
import 'package:example/src/interceptors/example_interceptor.dart';
import 'package:example/src/middlewares/example_middleware.dart';
import 'package:example/src/services/city_service.dart';

void main(List<String> args) async {
  final controllers = [
    CityController(CityService()),
  ];
  final errorHandlers = [ExampleErrorHandler()];
  final app = Dartness(
    port: 3000,
    controllers: controllers.map(
        (controller) => DartnessController(controller, controller.getRoutes())),
    middlewares: [
      ExampleMiddleware(),
    ],
    interceptors: [
      ExampleInterceptor(),
    ],
    errorHandlers: errorHandlers.expand((e) => e.getCatchHandlers()),
  );
  app.create();
}
