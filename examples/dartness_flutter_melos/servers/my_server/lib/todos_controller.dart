import 'dart:io';

import 'package:dartness_server/route.dart';
import 'package:dio/dio.dart';
import 'package:my_common/todo_list_response.dart';
import 'dart:math';

part 'todos_controller.g.dart';

@Controller('/todos')
@Header(HttpHeaders.contentTypeHeader, 'application/json')
class TodosController {
  final Dio _dio;

  TodosController(this._dio);

  @Get()
  Future<TodoListResponse> getTodos() async {
    var rng = Random();
    final userId = rng.nextInt(6);
    final result = await _dio.get('https://dummyjson.com/todos/user/$userId');
    return TodoListResponse.fromJson(result.data);
  }
}
