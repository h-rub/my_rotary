import 'package:flutter/material.dart';

class TaskInfo with ChangeNotifier {
  String _title = "";

  get title {
    return _title;
  }

  set title(String title) {
    _title = title;
    notifyListeners();
  }
}
