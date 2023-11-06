import 'package:dio/dio.dart';

class TodosService {
  final Dio _dio;

  TodosService(this._dio);

  Future<Map<String, dynamic>> getTodos() async {
    final result = await _dio.get('https://dummyjson.com/todos/user/5');
    return result.data as Map<String, dynamic>;
  }
}
