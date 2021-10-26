import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class InputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final String hint;
  final Widget widget;
  final bool isReadOnly;

  final bool isDescription;

  const InputField(
      {@required this.title,
      this.controller,
      @required this.hint,
      this.widget,
      this.isReadOnly,
      this.isDescription});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: titleTextStle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 14.0),
              height: widget.isDescription ? 104 : 52,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: widget.isDescription
                          ? TextInputType.multiline
                          : TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      autofocus: false,
                      cursorColor:
                          Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                      readOnly: widget.isReadOnly == null ? false : true,
                      controller: widget.controller,
                      style: subTitleTextStle,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: subTitleTextStle,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.widget == null ? Container() : widget.widget,
                ],
              ),
            )
          ],
        ));
  }
}
