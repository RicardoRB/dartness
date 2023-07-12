import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';
import 'package:example/src/services/city_service.dart';

import 'controllers/city_controller.dart';
import 'error_handlers/example_error_handler.dart';

part 'app.g.dart';

@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [
        CityController,
      ],
      providers: [
        CityService,
        ExampleErrorHandler,
      ],
      exports: [],
      imports: [],
    ),
  ),
)
class App {}
