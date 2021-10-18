import 'dart:convert';

import 'package:amplified_todo/providers/user_info.dart';
import 'package:amplified_todo/screens/home/home_page.dart';
import 'package:amplified_todo/utils/alert_dialog.dart';
import 'package:amplified_todo/utils/validators/validate_email.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

import 'package:amplified_todo/screens/register/register.dart';
import 'package:amplified_todo/utils/hex_color.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  final Color thirdColor = Color.fromRGBO(247, 168, 27, 1);

  // Controllers form
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Shared Preferencess
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = false;

  // Login API Call section
  signIn(String email, String password, userInfo) async {
    final SharedPreferences prefs = await _prefs;
    String url =
        "https://morning-retreat-88403.herokuapp.com/api/v1/auth/login/";
    Map body = {"email": email, "password": password};
    var jsonResponse;
    var res = await http.post(url, body: body);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");

      if (jsonResponse != Null) {
        setState(() {
          _isLoading = false;
        });

        prefs.setInt("user_id", jsonResponse['id']);
        prefs.setString("token", jsonResponse['token']);
        prefs.setString("email", jsonResponse['email']);

        userInfo.uid = jsonResponse['id'];
        userInfo.firstName = jsonResponse['first_name'];
        userInfo.lastName = jsonResponse['last_name'];
        userInfo.email = jsonResponse['email'];
        userInfo.company = jsonResponse['company'];
        userInfo.address = jsonResponse['address'];

        String urlPhoto =
            "https://morning-retreat-88403.herokuapp.com/api/v1/profile-pic/${userInfo.uid}";
        var res_photo = await http.get(urlPhoto);
        var jsonResponsePicture = json.decode(res_photo.body);
        userInfo.urlPicture = jsonResponsePicture['picture'];
        print("Picture User info: ${userInfo.urlPicture}");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }
    } else if (res.statusCode == 401) {
      setState(() {
        _isLoading = false;
      });
      print("No existe el usuario");
      showAlertDialog("Email o contraseña incorrectos", context);
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);

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
          margin: EdgeInsets.only(top: 230),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 22, left: 22, right: 22),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: <Widget>[
                Text(
                  'Bienvenido',
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
                      controller: _emailController,
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.mail_outline),
                        labelStyle: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.black, fontFamily: 'SFPro'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                        labelStyle: TextStyle(fontSize: 17)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      _emailController.text == "" ||
                              _passwordController.text == ""
                          ? showAlertDialog(
                              "Todos los campos son requeridos", context)
                          :
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => HomePage()),
                          //     ModalRoute.withName("/Home"));
                          // // Call login service
                          signIn(_emailController.text,
                              _passwordController.text, userInfo);
                    },
                    child: Text(
                      'Iniciar sesión',
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
                    child: Text(
                      'Recuperar contraseña',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "¿No tienes una cuenta? ",
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              color: Colors.black,
                              fontSize: 17,
                            )),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage())),
                            text: "Regístrate",
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
                  padding: const EdgeInsets.only(top: 90),
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
