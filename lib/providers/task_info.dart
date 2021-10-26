import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskInfo with ChangeNotifier {
  int _id;
  String _title = "";
  String _description = "";
  bool _isCompleted;

  String _full_name_assigned_to = "";
  String _dueDate = "";

  var _dateFormated;

  get id {
    return _id;
  }

  get title {
    return _title;
  }

  get description {
    return _description;
  }

  get dueDate {
    return _dueDate;
  }

  get full_name_assigned_to {
    return _full_name_assigned_to;
  }

  get dateFormated {
    return _dateFormated;
  }

  get isCompleted {
    return _isCompleted;
  }

  set title(String title) {
    _title = title;
    notifyListeners();
  }

  set id(int id) {
    _id = id;
    notifyListeners();
  }

  set description(String description) {
    _description = description;
    notifyListeners();
  }

  set full_name_assigned_to(String full_name_assigned_to) {
    _full_name_assigned_to = full_name_assigned_to;
    notifyListeners();
  }

  set dueDate(String dueDate) {
    _dueDate = dueDate;
    notifyListeners();
  }

  set formatDateTask(String stringDate) {
    var _dateFormated = DateFormat("dd/MM/yyyy")
        .format(DateFormat("yyyy-MM-dd").parse(stringDate));
  }

  set isCompleted(bool isCompleted) {
    _isCompleted = isCompleted;
    notifyListeners();
  }
}
