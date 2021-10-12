import 'package:amplified_todo/screens/home/home_page.dart';
import 'package:amplified_todo/screens/login/login.dart';
import 'package:amplified_todo/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
// dart async library we will refer to when setting up real time updates
import 'dart:async';

import 'package:amplified_todo/utils/validators/return_token.dart';

import 'screens/tasks/tasks_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  // This widget is the root of your application.
  Future<String> token = returnValueToken();
  @override
  Widget build(BuildContext context) {
    print(token);
    return MaterialApp(
      title: 'Rotary Club Monterrey',
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: token != null ? LoginPage() : HomePage(),
      debugShowCheckedModeBanner: false,
      initialRoute: token == null ? '/login' : '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        // When navigating to the "/" route, build the FirstScreen widget.
        '/profile': (context) => EditProfilePage(),
        '/tasks': (context) => TasksPage(),
      },
    );
  }
}
