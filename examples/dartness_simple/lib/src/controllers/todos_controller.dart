import 'dart:io';

import 'package:dartness_server/route.dart';
import 'package:example/src/services/todos_service.dart';

part 'todos_controller.g.dart';

@Controller('/todos')
@Header(HttpHeaders.contentTypeHeader, 'application/json')
class TodosController {
  final TodosService _todoService;

  TodosController(this._todoService);

  @Get()
  Future<Map<String, dynamic>> getAlive() {
    return _todoService.getTodos();
  }
}
