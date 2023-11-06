import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/modules.dart';
import 'package:dartness_server/server.dart';

import 'example_controller.dart';

part 'app.g.dart';

@Application(
  module: Module(
    metadata: ModuleMetadata(
      controllers: [
        ProviderMetadata(
          classType: ExampleController,
        ),
      ],
    ),
  ),
  options: DartnessApplicationOptions(
    port: int.fromEnvironment(
      'port',
      defaultValue: 3000,
    ),
  ),
)
class App {}
