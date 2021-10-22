import 'dart:convert';

import 'package:my_rotary/screens/login/login.dart';
import 'package:my_rotary/utils/alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  final Color thirdColor = Color.fromRGBO(247, 168, 27, 1);

  // Controllers
  TextEditingController _firstName_Controller = TextEditingController();
  TextEditingController _lastName_Controller = TextEditingController();
  TextEditingController _email_Controller = TextEditingController();
  TextEditingController _password_Controller = TextEditingController();
  TextEditingController _company_Controller = TextEditingController();
  TextEditingController _address_Controller = TextEditingController();

  // Shared Preferencess
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = false;

  // Login API Call section
  signUp(String firstName, String lastName, String email, String password,
      String company, String address) async {
    final SharedPreferences prefs = await _prefs;
    String url =
        "https://morning-retreat-88403.herokuapp.com/api/v1/auth/singup/";
    Map body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "company": company,
      "address": address
    };
    var jsonResponse;
    var res = await http.post(url, body: body);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");
      showAlertDialog(jsonResponse['message'], context);

      if (jsonResponse != Null) {
        setState(() {
          _isLoading = false;
        });
        //prefs.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image2.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 22, left: 22, right: 22),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: <Widget>[
                Text(
                  'Regístrate',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFPro',
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: _firstName_Controller,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person_outline),
                          labelStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _lastName_Controller,
                    style: TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Apellidos',
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(fontSize: 17)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: _email_Controller,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.mail_outline),
                          labelStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      obscureText: true,
                      controller: _password_Controller,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                          labelStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _company_Controller,
                    style: TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Compañia',
                        prefixIcon: Icon(Icons.business_center_outlined),
                        labelStyle: TextStyle(fontSize: 17)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: _address_Controller,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.home),
                          labelStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: MaterialButton(
                    onPressed: () {
                      _firstName_Controller.text == "" ||
                              _lastName_Controller.text == "" ||
                              _email_Controller.text == "" ||
                              _password_Controller.text == "" ||
                              _company_Controller.text == "" ||
                              _address_Controller.text == ""
                          ? showAlertDialog(
                              "Todos los campos son requeridos", context)
                          :
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => HomePage()),
                          //     ModalRoute.withName("/Home"));
                          // // Call login service
                          signUp(
                              _firstName_Controller.text,
                              _lastName_Controller.text,
                              _email_Controller.text,
                              _password_Controller.text,
                              _company_Controller.text,
                              _address_Controller.text);
                    }, //since this is only a UI app
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    color: primaryColor,
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "¿Ya tienes una cuenta? ",
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              color: Colors.black,
                              fontSize: 17,
                            )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pop(context),
                            text: "Inicia sesión",
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              color: thirdColor,
                              fontSize: 17,
                            ))
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Image(
                        image: AssetImage('assets/logo.png'),
                        height: 70,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
