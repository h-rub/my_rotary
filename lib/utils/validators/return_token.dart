import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> returnValueToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = await prefs.getString("token");
  return token;
}
