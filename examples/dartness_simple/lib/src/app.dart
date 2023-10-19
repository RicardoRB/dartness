import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';
import 'package:dartness_server/server.dart';
import 'package:example/src/controllers/city/city_module.dart';
import 'package:example/src/controllers/user/user_module.dart';
import 'package:example/src/services/city_service.dart';

import 'controllers/city/city_controller.dart';
import 'controllers/health_controller.dart';
import 'controllers/user/user_controller.dart';
import 'error_handlers/example_error_handler.dart';

part 'app.g.dart';

@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [
        ProviderMetadata(
          classType: HealthController,
        ),
      ],
      providers: [
        ProviderMetadata(
          classType: ExampleErrorHandler,
        ),
      ],
      exports: [],
      imports: [
        userModule,
        cityModule,
      ],
    ),
  ),
  options: DartnessApplicationOptions(
    port: int.fromEnvironment(
      'port',
      defaultValue: 8080,
    ),
  ),
)
class App {}
