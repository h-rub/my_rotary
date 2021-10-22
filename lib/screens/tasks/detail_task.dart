import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:my_rotary/theme.dart';
import 'package:get/get.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: WillPopScope(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [],
        ),
        onWillPop: () async {
          _updateTask();
          return true;
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: Material(
          color: Theme.of(context).bottomAppBarColor,
          shadowColor: Colors.black,
          elevation: 32.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    print("Marcando la tarea como completado");
                    //Navigator.pop(context);
                  },
                  child: Text(
                    'Eliminar',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("Marcando la tarea como completado");
                    //Navigator.pop(context);
                  },
                  child: Text(
                    'Marcar como completado',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      brightness: context.theme.brightness,
      title: Text(
        "Tarea 1",
        style: headingTextStyle,
      ),
      elevation: 4,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(CommunityMaterialIcons.delete_outline, color: Colors.red),
          ),
        ),
      ],
    );
  }

  bool isCompleted = false;

  void _updateTask() {
    print("Actualizando tarea");
  }
}
