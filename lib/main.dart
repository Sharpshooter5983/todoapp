import 'package:flutter/material.dart';
import 'today_page.dart';
import 'completedpage.dart';
import 'pomodoro_timer.dart';
import 'pomodoro_service.dart';

void main() {
  runApp(ToDoListApp());
}

class ToDoListApp extends StatefulWidget {
  @override
  _ToDoListAppState createState() => _ToDoListAppState();
}

class _ToDoListAppState extends State<ToDoListApp> {
  final PomodoroService pomodoroService = PomodoroService();

  @override
  void dispose() {
    pomodoroService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Your To-Do List",
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        primaryColor: Color.fromARGB(255, 59, 22, 147),
      ),
      home: TodoListScreen(pomodoroService: pomodoroService),
      routes: {
        '/completed': (context) => CompletedPage(),
        '/pomodoro': (context) => PomodoroTimer(pomodoroService: pomodoroService),
      },
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final PomodoroService pomodoroService;

  TodoListScreen({required this.pomodoroService});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todoItems = [];
  final List<String> _categories = ['Personal', 'Work', 'Shopping', 'Studying', 'Uncategorized'];

  List<TodoItem> getTodayTasks() {
    return _todoItems.where((item) => item.isScheduledForToday()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your To-do list"),
        actions: [
          ElevatedButton(
            child: Text("Lists"),
            onPressed: () {
              // bring user to the lists page (homepage)
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text("Completed"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/completed',
                arguments: _todoItems.where((item) => item.completed).toList(),
              );
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text("Today"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodayPage(todayTasks: getTodayTasks())),
              );
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            child: Text("Pomodoro"),
            onPressed: () {
              Navigator.pushNamed(context, '/pomodoro');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // something happens
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search thing happens
            },
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // help page happens
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _todoItems[index].title,
                ),
                onChanged: (value) {
                  setState(() {
                    _todoItems[index].title = value;
                  });
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _todoItems[index].completed,
                    onChanged: (value) {
                      setState(() {
                        _todoItems[index].completed = value ?? false;
                      });
                    },
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _todoItems[index].description = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      DropdownButton<String>(
                        value: _todoItems[index].category,
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _todoItems[index].category = newValue!;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text(_todoItems[index].dueDate == null
                            ? 'Set Due Date'
                            : '${_todoItems[index].dueDate!.month}/${_todoItems[index].dueDate!.day}/${_todoItems[index].dueDate!.year}'),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _todoItems[index].dueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != _todoItems[index].dueDate) {
                            setState(() {
                              _todoItems[index].dueDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text('Priority: '),
                      DropdownButton<int>(
                        value: _todoItems[index].priority,
                        items: List.generate(10, (i) => i + 1).map((priority) {
                          return DropdownMenuItem<int>(
                            value: priority,
                            child: Text(priority.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _todoItems[index].priority = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoItem();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem() {
    setState(() {
      _todoItems.add(TodoItem(title: "New Task", description: "Enter a description!"));
    });
  }
}

class TodoItem {
  String title;
  String description;
  bool completed;
  String category;
  DateTime? dueDate;
  int priority;
  List<Subtask> subtasks;

  TodoItem({
    required this.title,
    this.description = '',
    this.completed = false,
    this.category = 'Uncategorized',
    this.dueDate,
    this.priority = 1,
    this.subtasks = const [],
  });

  void addSubtask(Subtask subtask) {
    subtasks.add(subtask);
  }
  
  void removeSubtask(Subtask subtask){
    subtasks.remove(subtask);
  }

  bool get allSubtasksCompleted{
    return subtasks.isNotEmpty && subtasks.every((subtask) => subtask.completed);
  }

  bool isScheduledForToday() {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && 
           dueDate!.month == now.month && 
           dueDate!.day == now.day;
  }
}

class Subtask {
  String title;
  bool completed;

  Subtask({required this.title, this.completed = false});
}