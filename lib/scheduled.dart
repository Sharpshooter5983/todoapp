//second page for the "scheduled" page
import 'package:flutter/material.dart';
import 'dart:async';

class SecondPage extends StatelessWidget{
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your tasks today"),
      ),
      body: Center(
        child: Text("Where you can schedule what tasks you want to do")
      )
    );
  }
}

