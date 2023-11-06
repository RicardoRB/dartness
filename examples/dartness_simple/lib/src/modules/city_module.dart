import 'package:dartness_server/modules.dart';

import '../controllers/city_controller.dart';
import '../services/city_service.dart';

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
