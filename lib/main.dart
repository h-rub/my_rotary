import 'package:my_rotary/providers/task_info.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/home/home_page.dart';
import 'package:my_rotary/screens/login/login.dart';
import 'package:my_rotary/screens/profile/profile_page.dart';
import 'package:my_rotary/screens/tasks/add_task.dart';
import 'package:my_rotary/screens/tasks/my_tasks_page.dart';
import 'package:my_rotary/services/theme_services.dart';
import 'package:my_rotary/theme.dart';
import 'package:flutter/material.dart';
// dart async library we will refer to when setting up real time updates
import 'dart:async';
import 'package:get/get.dart';

import 'package:my_rotary/utils/validators/return_token.dart';
import 'package:provider/provider.dart';

import 'screens/profile/my_profile.dart';
import 'screens/profile/test_page.dart';
import 'screens/settings/settings_page.dart';
import 'screens/tasks/detail_task.dart';
import 'screens/tasks/details_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfo()),
        ChangeNotifierProvider(create: (_) => TaskInfo())
      ],
      child: GetMaterialApp(
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
        title: 'Rotary Club Monterrey',
        //home: token != null ? LoginPage() : HomePage(),
        debugShowCheckedModeBanner: false,
        initialRoute: token != null ? '/login' : '/',
        routes: {
          '/': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/me': (context) => MyProfile(),
          '/settings': (context) => SettingsPage(),
          // When navigating to the "/" route, build the FirstScreen widget.
          '/edit-profile': (context) => EditProfilePage(),
          '/tasks': (context) => TasksPage(),
          '/addTask': (context) => AddTaskPage(),
          '/myTasks': (context) => MyTasksPage(),
          '/test': (context) => TestPage(),
          '/detail': (context) => DetailsPageTask()
        },
      ),
    );
  }
}
