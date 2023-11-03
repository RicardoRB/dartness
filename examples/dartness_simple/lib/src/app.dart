import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';
import 'package:dartness_server/server.dart';
import 'package:dio/dio.dart';

import 'controllers/city_controller.dart';
import 'controllers/todos_controller.dart';
import 'controllers/user_controller.dart';
import 'error_handlers/example_error_handler.dart';
import 'modules/city_module.dart';
import 'modules/todos_module.dart';
import 'modules/user_module.dart';
import 'services/city_service.dart';
import 'services/todos_service.dart';

part 'app.g.dart';

Dio createDio() => Dio();

@Application(
  module: Module(
    metadata: ModuleMetadata(
      providers: [
        ProviderMetadata(
          classType: ExampleErrorHandler,
        ),
        ProviderMetadata(
          classType: Dio,
          useFactory: createDio,
        ),
      ],
      exports: [],
      imports: [
        userModule,
        cityModule,
        todosModule,
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
