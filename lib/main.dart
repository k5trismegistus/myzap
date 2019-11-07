import 'package:flutter/material.dart';

import 'pages/splash.dart';
import 'pages/login.dart';
import 'pages/top.dart';
import 'pages/addTaskPage.dart';

void main() => runApp(MyzapApp());

class MyzapApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MYZAP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => Login(),
        '/top': (context) => TopPage(title: 'What to do now?'),
        '/addTask': (context) => AddTaskPage()
      }
    );
  }
}