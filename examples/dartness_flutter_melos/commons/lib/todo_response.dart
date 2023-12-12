import 'package:json_annotation/json_annotation.dart';

part 'todo_response.g.dart';

@JsonSerializable()
class TodoResponse {
  int id;
  String todo;
  bool completed;
  int userId;

  TodoResponse({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TodoResponseToJson(this);
}
