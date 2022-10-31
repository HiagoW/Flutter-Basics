import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/initial_screen.dart';
import 'package:nosso_primeiro_projeto/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        // theme: tema,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskInherited(child: const InitialScreen()));
  }
}




