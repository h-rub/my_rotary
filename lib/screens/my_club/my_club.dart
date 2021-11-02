import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_rotary/screens/members/members_screen.dart';
import 'package:my_rotary/screens/tasks/tasks_page.dart';
import 'package:my_rotary/theme.dart';

import 'feed/feed.dart';
import 'notifications/notifications.dart';

class MyClubPage extends StatefulWidget {
  static const routeName = 'home';
  State<StatefulWidget> createState() => _MyClubPageState();
}

class _MyClubPageState extends State<MyClubPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    Text('Feed'),
    MembersPage(),
    NotificationPage(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Club Sierra Madre'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_search), label: 'Miembros'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
