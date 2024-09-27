import 'package:flutter/material.dart';
import 'package:listapp/main.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  List<TodoItem> _completedItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as List<TodoItem>;
    _completedItems = args;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Tasks"),
      ),
      body: ListView.builder(
        itemCount: _completedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_completedItems[index].title),
          );
        },
      ),
    );
  }
}