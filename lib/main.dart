import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myzap/pages/add_personal_place.dart';
import 'package:myzap/pages/personal_place_page.dart';
import 'package:myzap/pages/personal_places_page.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/top_page.dart';
import 'pages/add_task_page.dart';

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