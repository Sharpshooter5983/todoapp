import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'today_page.dart';
import 'completedpage.dart';
import 'pomodoro_timer.dart';
import 'pomodoro_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: ToDoListApp(),
    ),
  );
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
  final List<String> _categories = ['Personal', 'Work', 'Shopping', 'Studying', 'Uncategorized'];

  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Your To-do list"),
            actions: [
              ElevatedButton(
                child: Text("Lists"),
                onPressed: () {
                  // Navigate to lists page
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                child: Text("Completed"),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/completed',
                    arguments: todoProvider.todoItems.where((item) => item.completed).toList(),
                  );
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                child: Text("Today"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodayPage(todayTasks: todoProvider.todayTasks)),
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
                  // Open settings
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Perform search
                },
              ),
              IconButton(
                icon: Icon(Icons.help),
                onPressed: () {
                  // Open help page
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: todoProvider.todoItems.length,
            itemBuilder: (context, index) {
              final item = todoProvider.todoItems[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: item.title,
                    ),
                    onChanged: (value) {
                      item.title = value;
                      todoProvider.updateTodoItem(index, item);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: item.completed,
                        onChanged: (value) {
                          todoProvider.toggleCompleted(index);
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
                          item.description = value;
                          todoProvider.updateTodoItem(index, item);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            value: item.category,
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                item.category = newValue;
                                todoProvider.updateTodoItem(index, item);
                              }
                            },
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text(item.dueDate == null
                                ? 'Set Due Date'
                                : '${item.dueDate!.month}/${item.dueDate!.day}/${item.dueDate!.year}'),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: item.dueDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != item.dueDate) {
                                item.dueDate = picked;
                                todoProvider.updateTodoItem(index, item);
                              }
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
              todoProvider.addTodoItem(TodoItem(title: "New Task", description: "Enter a description!"));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}