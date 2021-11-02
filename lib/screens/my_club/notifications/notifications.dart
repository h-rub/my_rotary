import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Notificaciones',
                  style: GoogleFonts.lato(
                      color: Colors.grey[700],
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.grey[700],
                ),
              )
            ]),
            SizedBox(height: 40),
            Center(
              child: Text(
                'Hoy',
                style: GoogleFonts.lato(
                    color: Colors.grey[600],
                    fontSize: 15,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          0, // Move to right 10  horizontally
                          4, // Move to bottom 10 Vertically
                        ),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://content.api.news/v3/images/bin/a6923adbc7bece73803221613f410782',
                        )),
                    title: Text(
                      'Hernán Restrepo',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Te ha asignado una tarea',
                      style: GoogleFonts.lato(
                          color: Colors.grey[700],
                          letterSpacing: 1,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          '14:25',
                          style: GoogleFonts.lato(
                              color: Colors.grey[500],
                              letterSpacing: 0.6,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.list_alt,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    isThreeLine: false,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
