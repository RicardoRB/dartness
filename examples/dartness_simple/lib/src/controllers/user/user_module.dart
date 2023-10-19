import 'package:dartness_server/modules.dart';

import '../user/user_controller.dart';

const userModule = Module(
  metadata: ModuleMetadata(
    controllers: [
      ProviderMetadata(
        classType: UserController,
      ),
    ],
  ),
);
