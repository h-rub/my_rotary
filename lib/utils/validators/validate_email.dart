import 'package:flutter/material.dart';

String validateEmail(String value) {
  if (!(value.length > 0) && value.isNotEmpty) {
    return "Este campo es requerido";
  }
  return null;
}
