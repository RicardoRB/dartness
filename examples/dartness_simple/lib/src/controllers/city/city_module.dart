import 'package:dartness_server/modules.dart';

import '../../services/city_service.dart';
import 'city_controller.dart';

const cityModule = Module(
  metadata: ModuleMetadata(
    controllers: [
      ProviderMetadata(
        classType: CityController,
      ),
    ],
    providers: [
      ProviderMetadata(
        classType: CityService,
      ),
      ProviderMetadata(
        classType: CityService,
        name: 'CITY_SECOND',
      ),
    ],
  ),
);
