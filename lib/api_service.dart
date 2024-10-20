import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';  // import TodoItem

class APIService {
  static const String baseUrl = 'http://localhost:8080';  // Replace with your API base URL

  Future<List<TodoItem>> fetchTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      List<dynamic> todosJson = json.decode(response.body);
      return todosJson.map((json) => TodoItem(
        title: json['title'],
        description: json['description'] ?? '',
        completed: json['completed'] ?? false,
        category: json['category'] ?? 'Uncategorized',
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        priority: json['priority'] ?? 1,
      )).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(TodoItem todo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todo.title,
        'description': todo.description,
        'completed': todo.completed,
        'category': todo.category,
        'dueDate': todo.dueDate?.toIso8601String(),
        'priority': todo.priority,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(TodoItem todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${todo}'),  // NEED TO CHECK THISLINE
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todo.title,
        'description': todo.description,
        'completed': todo.completed,
        'category': todo.category,
        'dueDate': todo.dueDate?.toIso8601String(),
        'priority': todo.priority,
      }),
    );

    if (response.statusCode != 200) {
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