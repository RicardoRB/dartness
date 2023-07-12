import 'package:dartness_server/modules.dart';
import 'package:example/src/services/city_service.dart';

import 'src/controllers/city_controller.dart';

@Module(
  metadata: ModuleMetadata(
    controllers: [CityController],
    providers: [CityService],
  ),
)
class AppModule {}
