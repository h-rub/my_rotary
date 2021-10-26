import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier {
  int _uid;
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _company = "";
  String _address = "";
  String _biography = "";
  String _urlPicture = "";
  String _phone = "";

  get firstName {
    return _firstName;
  }

  get lastName {
    return _lastName;
  }

  get email {
    return _email;
  }

  get company {
    return _company;
  }

  get address {
    return _address;
  }

  get biography {
    return _biography;
  }

  get uid {
    return _uid;
  }

  get urlPicture {
    return _urlPicture;
  }

  get phone {
    return _phone;
  }

  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set company(String company) {
    _company = company;
    notifyListeners();
  }

  set address(String address) {
    _address = address;
    notifyListeners();
  }

  set biography(String biography) {
    _biography = biography;
    notifyListeners();
  }

  set uid(int uid) {
    _uid = uid;
    notifyListeners();
  }

  set urlPicture(String urlPicture) {
    _urlPicture = urlPicture;
    notifyListeners();
  }

  set phone(String phone) {
    _phone = phone;
    notifyListeners();
  }
}
