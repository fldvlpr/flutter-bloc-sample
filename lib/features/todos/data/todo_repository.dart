import 'package:flutter_bloc_sample/features/todos/data/todo_data_provider.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';

class TodoRepository {
  final TodoDataProvider _todoDataProvider;

  TodoRepository({required TodoDataProvider todoDataProvider}) 
      : _todoDataProvider = todoDataProvider;

  Future<List<Todo>> getTodos() async {
    final data = await _todoDataProvider.getTodos();
    return (data as List).map((json) => Todo.fromJson(json)).toList();
  }

  Future<Todo> getTodoById(int id) async {
    final data = await _todoDataProvider.getTodoById(id);
    return Todo.fromJson(data);
  }

  Future<Todo> createTodo(String title) async {
    final data = await _todoDataProvider.createTodo(title);
    return Todo.fromJson(data);
  }
}
