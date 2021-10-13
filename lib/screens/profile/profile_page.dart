import 'dart:convert';

import 'package:amplified_todo/screens/home/home_page.dart';
import 'package:amplified_todo/services/theme_services.dart';
import 'package:amplified_todo/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:amplified_todo/theme.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  final Color thirdColor = Color.fromRGBO(247, 168, 27, 1);

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
    String shared_first_name = await prefs.getString("first_name");
    String shared_last_name = await prefs.getString("last_name");
    String shared_email = await prefs.getString("email");
    String shared_company = await prefs.getString("company");
    String shared_adress = await prefs.getString("adress");
    String shared_bio = await prefs.getString("biography");
    String shared_picture = await prefs.getString("picture");
    setState(() {
      _firstName = shared_first_name;
      _lastName = shared_last_name;
      _email = shared_email;
      _company = shared_company;
      _adress = shared_adress;
      _biography = shared_bio;
      _picture = shared_picture;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _firstNameController =
        TextEditingController(text: _firstName);
    TextEditingController _lastNameController =
        TextEditingController(text: _lastName);
    TextEditingController _emailController =
        TextEditingController(text: _email);
    TextEditingController _companyController =
        TextEditingController(text: _company);
    TextEditingController _adressController =
        TextEditingController(text: _adress);
    TextEditingController _biographyController =
        TextEditingController(text: _biography);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          leading: GestureDetector(
            onTap: () {
              ThemeService().switchTheme();
              //notifyHelper.scheduledNotification();
              //notifyHelper.periodicalyNotification();
            },
            child: Icon(
                Get.isDarkMode ? FlutterIcons.sun_fea : FlutterIcons.moon_fea,
                color: Get.isDarkMode ? Colors.white : darkGreyClr),
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
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg-profile.jpg'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter),
                  ),
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
                                      image: _picture != null
                                          ? AssetImage('assets/nahaidi.png')
                                          : AssetImage(
                                              'assets/default-profile.png')
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
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: primaryColor,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      buildTextField(
                          "Nombre", "", false, false, _firstNameController),
                      buildTextField(
                          "Apellido", "", false, false, _lastNameController),
                      buildTextField(
                          "E-mail", "", false, false, _emailController),
                      buildTextField(
                          "Compañia", "", false, false, _companyController),
                      buildTextField(
                          "Dirección", "", false, false, _adressController),
                      buildTextField(
                          "Biografía", "", false, true, _biographyController),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {},
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

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      bool isTextAmplied,
      TextEditingController formController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: formController,
        maxLines: isTextAmplied ? 5 : 1,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
