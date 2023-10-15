import 'package:dartness_server/modules.dart';

import 'city_controller.dart';

const cityModule = Module(
  metadata: ModuleMetadata(
    controllers: [
      ProviderMetadata(
        classType: CityController,
      ),
    ],
  ),
);
