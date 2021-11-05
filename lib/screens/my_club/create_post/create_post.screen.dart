import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/widgets/button.dart';
import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
        appBar: _appBar(userInfo),
        body: Column(children: [
          Text("Photo"),
        ]));
  }

  _appBar(userInfo) {
    return AppBar(
        brightness: context.theme.brightness,
        title: Text(
          "Crear post",
          style: headingTextStyle,
        ),
        elevation: 4,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: MaterialButton(
              color: primaryClr,
              onPressed: () {},
              child: Text('Publicar',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }
}
