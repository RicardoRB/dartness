import 'package:dartness_server/modules.dart';
import 'package:dio/dio.dart';

import '../controllers/todos_controller.dart';
import '../services/todos_service.dart';

TodosService createTodosService(Dio dio) => TodosService(dio);

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
        useFactory: createTodosService,
      ),
    ],
  ),
);
