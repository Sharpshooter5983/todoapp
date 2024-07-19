import 'package:flutter/material.dart';
import 'scheduled.dart';
import 'completedpage.dart';

void main() {
  runApp(ToDoListApp());
}

class ToDoListApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Your To-Do List", //title at the top
      theme: ThemeData( //information about the theme of the app
        primaryColor: Color.fromARGB(255, 59, 22, 147), //primary color scheme of the app
      ),
      home: TodoListScreen(),
      routes: {
        '/completed': (context) => CompletedPage(),
      }
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}


class _TodoListScreenState extends State<TodoListScreen>{
  final List<TodoItem> _todoItems = [

    TodoItem(title: "Input tasks here!", description: "Enter your description!"), 
    TodoItem(title: "Input tasks here!", description: "Enter your description!"), 
    TodoItem(title: "Input tasks here!", description: "Enter your description!"), 
    
    
    
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Your To-do list"),
        actions:[
          
          ElevatedButton(
            child: Text("Lists"),
            onPressed: (){
              //bring user to the lists page (homepage)
            },
          ),
          SizedBox(width:10),
          ElevatedButton(
            child: Text("Completed"),
            onPressed: (){
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
            onPressed: (){
              //brings users to second page, "today"
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //something happens
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              //Search thing happens
            }
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: (){
              //help page happens
            }
          ),
        ]
      ),
      body: ListView.builder(
        itemCount: _todoItems.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: _todoItems[index].title,
                  ),
                  onChanged: (value){
                    setState((){  
                      _todoItems[index].title = value;
                    });
                  },
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: _todoItems[index].description,
                  ),
                  onChanged: (value){
                    setState((){
                      _todoItems[index].description = value;
                    });
                  }
                )
              ],
            ),
            trailing: Checkbox(
              value: _todoItems[index].completed,
              onChanged: (value){
                setState((){
                  _todoItems[index].completed = value?? false;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addTodoItem();
        },
        child: Icon(Icons.add), 
      ),
    );
  }

  void _addTodoItem(){
    // Add a new item
    setState(() {
      _todoItems.add(TodoItem(title: "Something new", description: "Enter a description!"));
    });
  }
}

class TodoItem{
  String title;
  String description;
  bool completed;
  TodoItem({required this.title, this.description = '', this.completed = false});
}

