import 'package:flutter/material.dart';

class SeparatorWidget extends StatefulWidget {
  @override
  _SeparatorWidgetState createState() => _SeparatorWidgetState();
}

class _SeparatorWidgetState extends State<SeparatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      width: MediaQuery.of(context).size.width,
      height: 11.0,
    );
  }
}
