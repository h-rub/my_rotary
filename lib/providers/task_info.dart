import 'package:flutter/material.dart';

class TaskInfo with ChangeNotifier {
  int _id;
  String _title = "";

  get id {
    return _id;
  }

  get title {
    return _title;
  }

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  set id(int id) {
    _id = id;
    notifyListeners();
  }
}
