import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/member_info.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:flutter/material.dart';
import 'package:my_rotary/theme.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:provider/provider.dart';

class MemberProfile extends StatefulWidget {
  MemberProfile({Key key}) : super(key: key);

  @override
  _MemberProfileState createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  final double profileHeight = 144;
  final double coverHeight = 280;
  @override
  Widget build(BuildContext context) {
    final memberInfo = Provider.of<MemberInfo>(context);

    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: context.theme.brightness,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(padding: EdgeInsets.zero, children: [
          buildTop(memberInfo),
          buildContent(memberInfo),
        ]));
  }

  Widget buildTop(memberInfo) {
    final top = coverHeight - profileHeight / 1.5;
    final bottom = profileHeight / 2.7;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: buildCoverImage(memberInfo)),
          Positioned(top: top, child: buildProfileImage(memberInfo)),
        ]);
  }

  Widget buildCoverImage(memberInfo) => Container(
        color: Colors.grey,
        child: Image.asset(
          "assets/bg-profile.jpg",
          width: double.infinity,
        ),
      );

  Widget buildProfileImage(memberInfo) => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: memberInfo.urlPicture != ""
            ? NetworkImage(
                "http://rotary.syncronik.com/media/${memberInfo.urlPicture}")
            : AssetImage("assets/default-profile.png"),
      );

  Widget buildContent(memberInfo) => Column(
        children: [
          const SizedBox(height: 30.0),
          Text("${memberInfo.firstName} ${memberInfo.lastName}",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Miembro",
              style: GoogleFonts.poppins(
                  fontSize: 20, color: context.theme.primaryColor)),
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
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${memberInfo.address}",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${memberInfo.phone}",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text("${memberInfo.email}",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Divider(),
          const SizedBox(height: 8),
          buildAbout(memberInfo),
        ],
      );

  Widget buildAbout(memberInfo) => Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Sobre ${memberInfo.firstName}",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 18),
            memberInfo.biography != ""
                ? Text("${memberInfo.biography}",
                    style: GoogleFonts.poppins(fontSize: 16))
                : Text("Miembro del Club Rotario Sierra Madre",
                    style: GoogleFonts.poppins(fontSize: 16))
          ]),
        ),
      );
}
