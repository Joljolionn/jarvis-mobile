import 'package:flutter/material.dart';
import 'package:jarvis_mobile/screens/list_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jarvis",
      theme: ThemeData.light(),
      home: ListScreen(),
    );
  }
}
