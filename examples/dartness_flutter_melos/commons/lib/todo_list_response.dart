import 'package:my_common/todo_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_list_response.g.dart';

@JsonSerializable()
class TodoListResponse {
  List<TodoResponse> todos;
  int total;
  int skip;
  int limit;

  TodoListResponse({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TodoListResponseToJson(this);
}
