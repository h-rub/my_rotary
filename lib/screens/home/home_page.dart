import 'dart:convert';

import 'package:amplified_todo/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'grid_dashboard.dart';
import 'package:amplified_todo/theme.dart';
import 'package:amplified_todo/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:amplified_todo/theme.dart';
import 'package:amplified_todo/widgets/button.dart';
import 'package:amplified_todo/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:amplified_todo/theme.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  String first_name;
  var picture;

  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Logout service
  // Logout API Call section
  logout() async {
    final SharedPreferences prefs = await _prefs;
    String email = await prefs.getString("email");
    String url = "http://localhost:8000/api/v1/auth/logout/";
    Map body = {"email": email};
    var jsonResponse;
    var res = await http.post(url, body: body);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print("Status code ${res.statusCode}");
      print("Response JSON ${res.body}");
      if (jsonResponse != Null) {
        await prefs.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    } else if (res.statusCode == 401) {
      print("No existe el token de usuario");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  loadProfileData() async {
    final SharedPreferences prefs = await _prefs;
    String shared_first_name = await prefs.getString("first_name");
    var picture_shared = await prefs.getString("picture");
    print(picture);
    setState(() {
      first_name = shared_first_name;
      picture = picture_shared;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        brightness: context.theme.brightness,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.logout, color: colorIcon),
                onPressed: () {
                  logout();
                }),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: picture != null
                          ? AssetImage("assets/nahaidi.png")
                          : AssetImage("assets/default-profile.png"),
                      fit: BoxFit.cover)),
            )
          ],
        ),
      ),
      body: Dashboard(first_name, context),
    );
  }
}

Widget Dashboard(String first_name, context) {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);

  Items item1 = new Items(
      title: "Mi perfil",
      subtitle: "Personaliza tu perfil",
      color: Colors.red,
      img: "assets/user.png",
      page: "/profile");

  Items item2 = new Items(
      title: "Tareas",
      subtitle: "Ver asignaciones",
      color: Colors.blue,
      img: "assets/clipboard.png",
      page: "/tasks");
  Items item3 = new Items(
      title: "Votaciones",
      subtitle: "Próximamente",
      color: Colors.orange,
      img: "assets/cabina-de-votacion.png",
      page: "voting");
  Items item4 = new Items(
      title: "Eventos",
      subtitle: "Proximamente",
      color: Colors.pink,
      img: "assets/calendario.png",
      page: "events");

  List<Items> myList = [item1, item2, item3, item4];
  var size = MediaQuery.of(context).size;

  return ListView(
    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.only(left: 25, right: 20, bottom: 20, top: 35),
    children: [
      first_name == null
          ? Text("Bienvenido 👀",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w600))
          : Text("Hola ${first_name} 👋",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w600)),
      SizedBox(height: 7),
      Text("Dashboard", style: titleTextStle),
      GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(top: 50),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: () {
                print("Tap ${data.page}");
                Navigator.of(context).pushNamed('${data.page}');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: data.color, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(data.img, width: 42, color: Colors.white),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    // Text(
                    //   data.event,
                    //   style: TextStyle(
                    //       color: Colors.white70,
                    //       fontSize: 11,
                    //       fontWeight: FontWeight.w600),
                    // ),
                  ],
                ),
              ),
            );
          }).toList()),
      Padding(
        padding: const EdgeInsets.only(top: 130),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Image(
              image: AssetImage(
                Get.isDarkMode ? "assets/logo-light.png" : "assets/logo.png",
              ),
              height: Get.isDarkMode ? 60 : 75,
            )),
          ],
        ),
      ),
    ],
  );
}

class Items {
  String title;
  String subtitle;
  Color color;
  String img;
  String page;
  Items({this.title, this.subtitle, this.color, this.img, this.page});
}
