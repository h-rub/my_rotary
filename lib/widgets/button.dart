import 'package:flutter/material.dart';
import 'package:amplified_todo/theme.dart';

class MyButton extends StatelessWidget {
  final Function onTap;
  final String label;

  MyButton({
    this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - 40;
    print(_width);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: _width,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}