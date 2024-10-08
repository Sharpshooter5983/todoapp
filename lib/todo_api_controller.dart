import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'todo_provider.dart';  // Make sure this path is correct

class TodoApiController {
  final String baseUrl;
  
  TodoApiController({required this.baseUrl});

  // Get all todo items
  Future<List<TodoItem>> getAllTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));
    
    if (response.statusCode == 200) {
      List<dynamic> todoJson = json.decode(response.body);
      return todoJson.map((json) => TodoItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Get todo items for today
  Future<List<TodoItem>> getTodayTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/todos/today'));
    
    if (response.statusCode == 200) {
      List<dynamic> todoJson = json.decode(response.body);
      return todoJson.map((json) => TodoItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load today\'s todos');
    }
  }

  // Create a new todo item
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

  // Update an existing todo item
  Future<TodoItem> updateTodo(int index, TodoItem todo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$index'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    
    if (response.statusCode == 200) {
      return TodoItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // Toggle todo completion status
  Future<TodoItem> toggleTodoComplete(int index) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/todos/$index/toggle'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return TodoItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to toggle todo completion');
    }
  }
}



class TodoProviderWithApi extends TodoProvider {
  final TodoApiController apiController;
  bool _isLoading = false;

  TodoProviderWithApi({required this.apiController});

  bool get isLoading => _isLoading;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final todos = await apiController.getAllTodos();
      todoItems = todos;
    } catch (e) {
      print('Error loading todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> addTodoItem(TodoItem item) async {
    try {
      final newTodo = await apiController.createTodo(item);
      super.addTodoItem(newTodo);
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  @override
  Future<void> updateTodoItem(int index, TodoItem item) async {
    try {
      final updatedTodo = await apiController.updateTodo(index, item);
      super.updateTodoItem(index, updatedTodo);
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  @override
  Future<void> toggleCompleted(int index) async {
    try {
      final updatedTodo = await apiController.toggleTodoComplete(index);
      super.updateTodoItem(index, updatedTodo);
    } catch (e) {
      print('Error toggling todo completion: $e');
    }
  }
}