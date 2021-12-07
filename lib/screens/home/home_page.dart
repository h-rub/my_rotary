import 'dart:async';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/login/login.dart';
import 'package:my_rotary/services/profile_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:math' as math; // import this

import 'grid_dashboard.dart';
import 'package:my_rotary/theme.dart';
import 'package:my_rotary/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';
import 'package:my_rotary/widgets/button.dart';
import 'package:my_rotary/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

import 'package:skeleton_text/skeleton_text.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String first_name;
  var picture;

  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Logout service
  // Logout API Call section
  logout() async {
    final SharedPreferences prefs = await _prefs;
    String email = await prefs.getString("email");
    String url = "http://rotary.syncronik.com/api/v1/auth/logout/";
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

  String url_image;
  String bio_shared;

  loadProfileData() async {
    setState(() {
      isLoading = true;
    });
    print("Cargando datos");
    final SharedPreferences prefs = await _prefs;
    int user_id = await prefs.getInt("user_id");
    String token = await prefs.getString("token");

    String url = "http://rotary.syncronik.com/api/v1/profile-pic/${user_id}";
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {
        'Authorization': "Token ${token}",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);

      var picture_json = jsonResponse['picture'];
      ProfileServices().saveProfileURL(jsonResponse['picture']);
      var urlPictureLoaded = ProfileServices().loadURLPictureProfile();

      var bio = jsonResponse['bio'];

      print(picture_json);

      //await prefs.setString("picture", jsonResponse['picture']);
      // print("Status code ${res.statusCode}");
      // print("Response JSON ${jsonResponse}");
      setState(() {
        url_image = urlPictureLoaded;
        bio_shared = bio;
        isLoading = false;
      });
      //print(data);
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
    print(picture);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfileData();
  }

  @override
  void dipose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    userInfo.biography = bio_shared;
    url_image = ProfileServices().loadURLPictureProfile();
    userInfo.urlPicture = url_image;

    return isLoading
        ? buildLoading(context, userInfo)
        : buildScaffold(context, userInfo);
  }

  Scaffold buildLoading(BuildContext context, UserInfo userInfo) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        brightness: context.theme.brightness,
        elevation: 0,
        title: SkeletonAnimation(
          shimmerColor: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          shimmerDuration: 1000,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: IconButton(
                    icon: Icon(Icons.logout, color: colorIcon),
                    onPressed: () {
                      logout();
                    }),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/me');
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/default-profile.png"),
                          fit: BoxFit.cover)),
                ),
              )
            ],
          ),
        ),
      ),
      body: LoadingDashboard(context),
    );
  }

  Scaffold buildScaffold(BuildContext context, UserInfo userInfo) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        brightness: context.theme.brightness,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: IconButton(
                  icon: Icon(Icons.logout, color: colorIcon),
                  onPressed: () {
                    logout();
                  }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/me');
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: userInfo.urlPicture != ""
                            ? NetworkImage(
                                "http://rotary.syncronik.com/media/${userInfo.urlPicture}")
                            : AssetImage("assets/default-profile.png"),
                        fit: BoxFit.cover)),
              ),
            )
          ],
        ),
      ),
      body: Dashboard(userInfo.firstName, context),
    );
  }
}

Widget LoadingDashboard(context) {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);

  Items item1 = new Items(
      title: "Mi club",
      subtitle: "Sierra Madre",
      color: Colors.grey,
      img: "assets/club.png",
      page: "/my-club");

  // Items item5 = new Items(
  //     title: "Mi club",
  //     subtitle: "Sierra Madre",
  //     color: Colors.red,
  //     img: "assets/user.png",
  //     page: "/me");

  Items item2 = new Items(
      title: "Tareas",
      subtitle: "Ver asignaciones",
      color: Colors.grey,
      img: "assets/clipboard.png",
      page: "/tasks");
  Items item3 = new Items(
      title: "Votaciones",
      subtitle: "Tu opinión cuenta",
      color: Colors.grey,
      img: "assets/cabina-de-votacion.png",
      page: "/polls-demo");
  Items item4 = new Items(
      title: "Eventos",
      subtitle: "Proximamente",
      color: Colors.grey,
      img: "assets/calendario.png",
      page: "events");

  List<Items> myList = [item1, item2, item3, item4];
  var size = MediaQuery.of(context).size;

  return ListView(
    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.only(left: 25, right: 20, bottom: 20, top: 35),
    children: [
      SkeletonAnimation(
        shimmerColor: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        shimmerDuration: 1000,
        child: Container(width: 50, height: 50),
      ),
      SizedBox(height: 7),
      SkeletonAnimation(
        shimmerColor: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        shimmerDuration: 1000,
        child: Container(width: 30, height: 30),
      ),
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
              child: SkeletonAnimation(
                shimmerColor: Colors.grey[200],
                shimmerDuration: 1000,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(data.img, width: 42, color: Colors.white),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        data.title,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      // Text(
                      //   data.event,
                      //   style: GoogleFonts.poppins(
                      //       color: Colors.white70,
                      //       fontSize: 11,
                      //       fontWeight: FontWeight.w600),
                      // ),
                    ],
                  ),
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

Widget Dashboard(String first_name, context) {
  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);

  Items item1 = new Items(
      title: "Mi club",
      subtitle: "Sierra Madre",
      color: Colors.red,
      img: "assets/club.png",
      page: "/my-club");

  // Items item5 = new Items(
  //     title: "Mi club",
  //     subtitle: "Sierra Madre",
  //     color: Colors.red,
  //     img: "assets/user.png",
  //     page: "/me");

  Items item2 = new Items(
      title: "Tareas",
      subtitle: "Ver asignaciones",
      color: Colors.blue,
      img: "assets/clipboard.png",
      page: "/tasks");
  Items item3 = new Items(
      title: "Votaciones",
      subtitle: "Tu opinión cuenta",
      color: Colors.orange,
      img: "assets/cabina-de-votacion.png",
      page: "/polls-demo");
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
              style: GoogleFonts.poppins(
                  fontSize: 32, fontWeight: FontWeight.w600))
          : Text("Hola ${first_name} 👋",
              style: GoogleFonts.poppins(
                  fontSize: 32, fontWeight: FontWeight.w600)),
      SizedBox(height: 7),
      Text("Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 20,
          )),
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
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.poppins(
                          color: Colors.white38,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    // Text(
                    //   data.event,
                    //   style: GoogleFonts.poppins(
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
