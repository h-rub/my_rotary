import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/widgets/button.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController _contentController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    _isButtonDisabled = true;
  }

  Future _publish(id_user, content_post) async {
    print("Añadiendo post");

    print("id ${id_user}");
    print("post ${content_post}");

    var jsonResponse;

    // TODO Send user to assigned to

    final res = await http.post(
      Uri.parse('http://rotary.syncronik.com/api/v1/myclub/post/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id_user': id_user,
        'content': content_post,
      }),
    );
    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      print("Status code ${res.statusCode}");
      print("Response JSON ${jsonResponse}");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      appBar: _appBar(_contentController, userInfo),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: [
              buildProfile(userInfo),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  print('First text field: $text');
                },
                controller: _contentController,
                decoration: new InputDecoration.collapsed(
                    hintStyle: TextStyle(fontSize: 19),
                    hintText: '¿Que estás pensando?'),
                maxLines: 22,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 28.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 14.0),
                        Text('Foto',
                            style: GoogleFonts.poppins(
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ))
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.video_label,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 14.0),
                        Text('Video',
                            style: GoogleFonts.poppins(
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        SizedBox(width: 14.0),
                        Text('Estoy aquí',
                            style: GoogleFonts.poppins(
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 28.0,
                          color: Colors.cyan,
                        ),
                        SizedBox(width: 14.0),
                        Text('Crear evento',
                            style: GoogleFonts.poppins(
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ]),
    );
  }

  Widget buildProfile(userInfo) {
    return Row(children: [
      CircleAvatar(
        radius: 22.0,
        backgroundImage: NetworkImage(
            "http://rotary.syncronik.com/media/${userInfo.urlPicture}"),
      ),
      SizedBox(
        width: 10,
      ),
      Text("${userInfo.firstName} ${userInfo.lastName}",
          style: GoogleFonts.poppins(
            textStyle: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode ? Colors.white : Colors.black),
          ))
    ]);
  }

  _appBar(
    _contentController,
    userInfo,
  ) {
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
              onPressed: () {
                _validateInputs(_contentController, userInfo);
              },
              child: Text('Publicar',
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  _validateInputs(_contentController, userInfo) {
    if (_contentController.text.isNotEmpty) {
      _publish(userInfo.uid, _contentController.text);
      //Get.back();
    } else if (_contentController.text.isEmpty) {
      Get.snackbar(
        "Requerido",
        "El contenido del post es requerido",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("############ SOMETHING BAD HAPPENED #################");
    }
  }
}
