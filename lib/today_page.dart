import 'package:flutter/material.dart';
import 'main.dart';  // Import this to use TodoItem

class TodayPage extends StatelessWidget {
  final List<TodoItem> todayTasks;

  const TodayPage({Key? key, required this.todayTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tasks today"),
      ),
      body: todayTasks.isEmpty
          ? Center(child: Text("No tasks scheduled for today"))
          : ListView.builder(
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todayTasks[index].title),
                  subtitle: Text(todayTasks[index].description),
                  trailing: Checkbox(
                    value: todayTasks[index].completed,
                    onChanged: (bool? value) {
                      // You might want to implement a way to update the original list here
                    },
                  ),
                );
              },
            ),
    );
  }
}