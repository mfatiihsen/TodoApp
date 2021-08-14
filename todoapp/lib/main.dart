import 'package:flutter/material.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'package:todoapp/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: WelcomeScreen(),
    );
  }
}
