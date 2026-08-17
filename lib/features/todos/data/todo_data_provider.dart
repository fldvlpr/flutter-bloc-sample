import 'package:flutter_bloc_sample/core/network/api_client.dart';

class TodoDataProvider {
  final ApiClient _apiClient;

  TodoDataProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<dynamic> getTodos() async {
    return await _apiClient.get('/todos');
  }

  Future<dynamic> getTodoById(int id) async {
    return await _apiClient.get('/todos/$id');
  }

  Future<dynamic> createTodo(String title) async {
    return await _apiClient.post('/todos', {
      'title': title,
      'completed': false,
      'userId': 1, 
    });
  }
}
