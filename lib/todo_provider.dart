import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodoItem {
  String title;
  String description;
  bool completed;
  String category;
  DateTime? dueDate;

  TodoItem({
    required this.title,
    this.description = '',
    this.completed = false,
    this.category = 'Uncategorized',
    this.dueDate,
  });

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

  List<TodoItem> get todoItems => _todoItems;

  List<TodoItem> get todayTasks => _todoItems.where((item) => item.isScheduledForToday()).toList();

  void addTodoItem(TodoItem item) {
    _todoItems.add(item);
    notifyListeners();
  }

  void updateTodoItem(int index, TodoItem item) {
    _todoItems[index] = item;
    notifyListeners();
  }

  void toggleCompleted(int index) {
    _todoItems[index].completed = !_todoItems[index].completed;
    notifyListeners();
  }
}