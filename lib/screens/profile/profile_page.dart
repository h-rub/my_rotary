import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/services/profile_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:my_rotary/screens/home/home_page.dart';
import 'package:my_rotary/services/theme_services.dart';
import 'package:my_rotary/utils/alert_dialog.dart';
import 'package:my_rotary/widgets/input_field.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:get/get.dart' hide FormData, Response;
import 'package:my_rotary/theme.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  final Color thirdColor = Color.fromRGBO(247, 168, 27, 1);

  int _user_id;
  String _firstName;
  String _lastName;
  String _email;
  String _company;
  String _adress;
  String _biography;
  String _picture;

  // Shared Preferencess
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadData() async {
    final SharedPreferences prefs = await _prefs;

    // prefs.setString("token", jsonResponse['token']);
    // prefs.setString("email", jsonResponse['email']);
    // prefs.setString("first_name", jsonResponse['first_name']);
    // prefs.setString("last_name", jsonResponse['last_name']);
    // prefs.setString("company", jsonResponse['company']);
    // prefs.setString("picture", jsonResponse['picture']);
    // prefs.setString("biography", jsonResponse['biography']);
    loadProfileData();
  }

  loadProfileData() async {
    final SharedPreferences prefs = await _prefs;
    int shared_user_id = await prefs.getInt("user_id");

    setState(() {
      _user_id = shared_user_id;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Back To old Screen");
    print(_picture);
    ProfileServices().saveProfileURL(_picture);
    super.dispose();
  }

  @override
  Future sendFiletodjango(File file, userInfo) async {
    final SharedPreferences prefs = await _prefs;
    var endPoint = "http://rotary.syncronik.com/api/v1/profile-pic/${_user_id}";

    final request = http.MultipartRequest("POST", Uri.parse(endPoint));

    final headers = {"Content-type": "multipart/form-data"};

    if (file == null) {
      return;
    } else {
      request.files.add(http.MultipartFile(
          'file', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split("/").last));

      request.headers.addAll(headers);
      final response = await request.send();

      http.Response res = await http.Response.fromStream(response);
      final resJson = jsonDecode(res.body);
      await prefs.setString("picture", resJson['url_picture']);
      print(resJson);
      userInfo.urlPicture = resJson['url_picture'];
      setState(() {
        _picture = resJson['url_picture'];
      });
      ProfileServices().saveProfileURL(resJson['url_picture']);
    }
  }

  File _image;

  Future getImage(userInfo) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      Permission.photos.request();
    }
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      sendFiletodjango(_image, userInfo);
      print(_image);
    });
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    TextEditingController _firstNameController =
        TextEditingController(text: userInfo.firstName);
    TextEditingController _lastNameController =
        TextEditingController(text: userInfo.lastName);
    TextEditingController _emailController =
        TextEditingController(text: userInfo.email);
    TextEditingController _companyController =
        TextEditingController(text: userInfo.company);
    TextEditingController _adressController =
        TextEditingController(text: userInfo.address);
    TextEditingController _biographyController =
        TextEditingController(text: userInfo.biography);

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
          title: Text(
            "Editar mi perfil",
            style: headingTextStyle,
          ),
          elevation: 0,
          brightness: context.theme.brightness,
          backgroundColor: context.theme.backgroundColor,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                //ThemeService().switchTheme();
                //notifyHelper.scheduledNotification();
                //notifyHelper.periodicalyNotification();
              },
              child: Icon(Icons.arrow_back_ios,
                  color: Get.isDarkMode ? Colors.white : darkGreyClr)
              // Get.isDarkMode ? FlutterIcons.sun_fea : FlutterIcons.moon_fea,
              // color: Get.isDarkMode ? Colors.white : darkGreyClr),
              ),
          actions: [
            SizedBox(
              width: 20,
            ),
          ]),
      body: Container(
        //padding: EdgeInsets.only(left: 25, right: 20, bottom: 20, top: 35),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/bg-profile.jpg'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter),
                      ),
                    ),
                    Positioned(
                        bottom: 155,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: primaryColor,
                          ),
                          child: IconButton(
                            onPressed: () => getImage(userInfo),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 120, bottom: 22, left: 22, right: 22),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: userInfo.urlPicture != ""
                                        ? NetworkImage(
                                            "http://rotary.syncronik.com/media/${userInfo.urlPicture}")
                                        : AssetImage(
                                            "assets/default-profile.png"),
                                    //NetworkImage(
                                    //"https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                  )),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 0,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: primaryColor,
                                  ),
                                  child: IconButton(
                                    onPressed: () => getImage(userInfo),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Nombre",
                        hint: "Ingresa tu nombre",
                        isDescription: false,
                        controller: _firstNameController,
                      ),
                      InputField(
                        title: "Apellido",
                        hint: "Ingresa tu apellido",
                        isDescription: false,
                        controller: _lastNameController,
                      ),
                      InputField(
                        title: "E-mail",
                        hint: "Ingresa tu correo",
                        isDescription: false,
                        controller: _emailController,
                      ),
                      InputField(
                        title: "Compañia",
                        hint: "Ingresa tu compañia",
                        isDescription: false,
                        controller: _companyController,
                      ),
                      InputField(
                        title: "Dirección",
                        hint: "Ingresa tu dirección",
                        isDescription: false,
                        controller: _adressController,
                      ),
                      InputField(
                        title: "Biografía",
                        hint: "Cuéntanos un poco sobre ti",
                        isDescription: true,
                        controller: _biographyController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlineButton(
                            color: context.theme.backgroundColor,
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("CANCELAR",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ),
                          RaisedButton(
                            onPressed: () {
                              print(_firstNameController.text);
                            },
                            color: primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "GUARDAR",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
