import 'package:flutter/material.dart';

void showAlertDialog(String message, context) {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              color: primaryColor,
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
