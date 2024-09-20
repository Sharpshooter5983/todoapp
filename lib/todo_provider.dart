import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

class TodoItem {
  int? id;
  String title;
  String description;
  bool completed;
  String category;
  DateTime? dueDate;

  TodoItem({
    this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.category = 'Uncategorized',
    this.dueDate,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      category: json['category'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  bool isScheduledForToday() {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && 
           dueDate!.month == now.month && 
           dueDate!.day == now.day;
  }
}

class TodoProvider extends ChangeNotifier {
  List<TodoItem> _todoItems = [];
  final ApiService _apiService = ApiService();

  List<TodoItem> get todoItems => _todoItems;

  List<TodoItem> get todayTasks => _todoItems.where((item) => item.isScheduledForToday()).toList();

  Future<void> fetchTodos() async {
    try {
      _todoItems = await _apiService.fetchTodos();
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodoItem(TodoItem item) async {
    try {
      final newItem = await _apiService.createTodo(item);
      _todoItems.add(newItem);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodoItem(int index, TodoItem item) async {
    try {
      final updatedItem = await _apiService.updateTodo(item);
      _todoItems[index] = updatedItem;
      notifyListeners();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> toggleCompleted(int index) async {
    try {
      _todoItems[index].completed = !_todoItems[index].completed;
      await _apiService.updateTodo(_todoItems[index]);
      notifyListeners();
    } catch (e) {
      print('Error toggling todo completion: $e');
    }
  }

  Future<void> deleteTodoItem(int index) async {
    try {
      await _apiService.deleteTodo(_todoItems[index].id!);
      _todoItems.removeAt(index);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}