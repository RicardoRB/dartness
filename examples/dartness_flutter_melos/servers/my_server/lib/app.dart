import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';
import 'package:dartness_server/server.dart';
import 'package:dio/dio.dart';

import 'hello_world_controller.dart';
import 'todos_controller.dart';

part 'app.g.dart';

Dio createDio() => Dio();

@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [
        ProviderMetadata(
          classType: ExampleController,
        ),
        ProviderMetadata(
          classType: TodosController,
        ),
      ],
      providers: [
        ProviderMetadata(
          classType: Dio,
          useFactory: createDio,
        ),
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
