import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myzap/pages/addPersonalPlace.dart';
import 'package:myzap/pages/personalPlacePage.dart';
import 'package:myzap/pages/personalPlacesPage.dart';

import 'pages/splash.dart';
import 'pages/login.dart';
import 'pages/top.dart';
import 'pages/addTaskPage.dart';

void main()  async {
  await DotEnv().load('.env');
  print(DotEnv().env);
  runApp(MyzapApp());
}

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
        '/addTask': (context) => AddTaskPage(),
        '/personalPlaces': (context) => PersonalPlacesPage(),
        '/addPersonalPlace': (context) => AddPersonalPlacePage(),
        '/personalPlace': (context) => PersonalPlacePage(),
      }
    );
  }
}