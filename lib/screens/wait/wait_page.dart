import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_rotary/theme.dart';
import 'package:get/get.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({Key key}) : super(key: key);

  @override
  _WaitPageState createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.primaryColor,
        title: Text("Cuenta en revisión"),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Image.asset('assets/waitlist.png'),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Ya casi lo tienes 🙌",
                  style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Tu cuenta ha sido enviada a revisión. Una vez sea aprobada por el club podrás acceder a la app, te notificaremos por correo cuando esto pase",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  height: 50,
                  minWidth: 400,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.orange.shade400,
                  child: Text(
                    "Revisar estado",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
