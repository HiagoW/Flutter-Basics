import 'package:flutter/material.dart';

final tema = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(250, 26, 35, 126),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(250, 255, 179, 0),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    elevation: 10,
  ),
  textTheme: const TextTheme(
    bodyText2: TextStyle(
        color: Colors.black, fontStyle: FontStyle.italic, fontSize: 20),
    headline4: TextStyle(
        color: Color.fromARGB(250, 26, 35, 126),
        fontWeight: FontWeight.bold,
        fontSize: 40),
  ),
);
