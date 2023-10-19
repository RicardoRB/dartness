import 'package:dartness_server/modules.dart';
import 'package:example/src/services/city_service.dart';

import 'src/controllers/city/city_controller.dart';

@Module(
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
    ],
  ),
)
class AppModule {}
