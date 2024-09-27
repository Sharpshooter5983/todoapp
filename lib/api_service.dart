/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo_provider.dart';

class ApiService {
  final String baseUrl = 'https://your-api-base-url.com/api'; // Replace with your actual API base URL

  Future<List<TodoItem>> fetchTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      List<dynamic> todosJson = json.decode(response.body);
      return todosJson.map((json) => TodoItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<TodoItem> createTodo(TodoItem todo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      return TodoItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }

  Future<TodoItem> updateTodo(TodoItem todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      return TodoItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }
}
*/