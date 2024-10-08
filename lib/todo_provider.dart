import 'package:flutter/foundation.dart';

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

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      title: json['title'],
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      category: json['category'] ?? 'Uncategorized',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  List<TodoItem> get todoItems => _todoItems;
  
  // Add this setter
  set todoItems(List<TodoItem> items) {
    _todoItems = items;
    notifyListeners();
  }

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