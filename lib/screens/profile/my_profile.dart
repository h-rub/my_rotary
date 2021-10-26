import 'package:my_rotary/providers/user_info.dart';
import 'package:flutter/material.dart';
import 'package:my_rotary/theme.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final double profileHeight = 144;
  final double coverHeight = 280;
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);

    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: context.theme.brightness,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/edit-profile');
                  },
                  child: Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                  child: Icon(Icons.settings),
                )),
          ],
        ),
        body: ListView(padding: EdgeInsets.zero, children: [
          buildTop(userInfo),
          buildContent(userInfo),
        ]));
  }

  Widget buildTop(userInfo) {
    final top = coverHeight - profileHeight / 1.5;
    final bottom = profileHeight / 2.7;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: buildCoverImage(userInfo)),
          Positioned(top: top, child: buildProfileImage(userInfo)),
        ]);
  }

  Widget buildCoverImage(userInfo) => Container(
        color: Colors.grey,
        child: Image.asset(
          "assets/bg-profile.jpg",
          width: double.infinity,
        ),
      );

  Widget buildProfileImage(userInfo) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: userInfo.urlPicture != ""
            ? NetworkImage(
                "http://rotary.syncronik.com/media/${userInfo.urlPicture}")
            : AssetImage("assets/default-profile.png"),
      );

  Widget buildContent(userInfo) => Column(
        children: [
          const SizedBox(height: 30.0),
          Text("${userInfo.firstName} ${userInfo.lastName}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Miembro",
              style:
                  TextStyle(fontSize: 20, color: context.theme.primaryColor)),
          const SizedBox(height: 8),
          Divider(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Información de contacto",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${userInfo.address}",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${userInfo.phone}",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${userInfo.email}",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Divider(),
          const SizedBox(height: 8),
          buildAbout(userInfo),
        ],
      );

  Widget buildAbout(userInfo) => Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Sobre mi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            Text("${userInfo.biography}", style: TextStyle(fontSize: 16))
          ]),
        ),
      );
}
