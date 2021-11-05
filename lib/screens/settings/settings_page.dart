import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/login/login.dart';
import 'package:my_rotary/services/theme_services.dart';
import 'package:my_rotary/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:get/get.dart' hide FormData, Response;
import 'package:my_rotary/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = Get.isDarkMode ? true : false;

  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(userInfo),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Apariencia',
            tiles: [
              SettingsTile.switchTile(
                title: 'Modo Oscuro (Beta)',
                leading: Icon(FlutterIcons.moon_fea),
                switchValue: isSwitched,
                onToggle: (bool value) {
                  ThemeService().switchTheme();
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Mi cuenta',
            tiles: [
              SettingsTile(
                  title: 'Cerrar sesión',
                  leading: Icon(Icons.logout),
                  onPressed: (BuildContext context) {
                    logout();
                  }),
              SettingsTile(
                  titleTextStyle:
                      GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                  title: 'Eliminar mi cuenta',
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: (BuildContext context) {}),
            ],
          ),
        ],
      ),
    );
  }

  _appBar(userInfo) {
    return AppBar(
      brightness: context.theme.brightness,
      backgroundColor: context.theme.backgroundColor,
      title: Text(
        "Configuraciones",
        style: headingTextStyle,
      ),
      elevation: 4,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
      ),
    );
  }
}
