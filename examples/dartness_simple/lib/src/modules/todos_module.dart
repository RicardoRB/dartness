import 'package:dartness_server/modules.dart';

import '../controllers/todos_controller.dart';
import '../services/todos_service.dart';

const todosModule = Module(
  metadata: ModuleMetadata(
    controllers: [
      ProviderMetadata(
        classType: TodosController,
      ),
    ],
    providers: [
      ProviderMetadata(
        classType: TodosService,
      ),
    ],
  ),
);
