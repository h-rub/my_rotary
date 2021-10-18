import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ProfileServices {
  final _box = GetStorage();
  final _key = 'url_picture';

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  String loadURLPictureProfile() => _box.read(_key) ?? null;

  /// Save isDarkMode to local storage
  void saveProfileURL(String url_picture) => _box.write(_key, url_picture);

  /// Switch theme and save to local storage
  // void switchTheme() {
  //   Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
  //   _saveThemeToBox(!_loadThemeFromBox());
  // }
  String switchPhoto() {
    String photo = loadURLPictureProfile();
    return "https://morning-retreat-88403.herokuapp.com/media/${photo}";
  }
}
