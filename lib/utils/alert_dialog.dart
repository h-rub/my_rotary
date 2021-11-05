import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
