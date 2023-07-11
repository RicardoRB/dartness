import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';

import 'controllers/city_controller.dart';
import 'error_handlers/example_error_handler.dart';
import 'services/city_service.dart';

class App {
  Future<void> main() async {
    final app = Dartness();
    await app.create(AppModule());
  }
}

class AppModule implements Module {
  @override
  ModuleMetadata get metadata => ModuleMetadata(
        controllers: [
          CityDartnessController(CityController(CityService())),
        ],
        providers: [
          ExampleDartnessErrorHandler(ExampleErrorHandler()),
        ],
        exports: [],
        imports: [],
      );
}
