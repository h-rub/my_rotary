import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = Color.fromRGBO(23, 69, 143, 1);
final Color darkGreyClr = Color.fromRGBO(11, 16, 38, 1);
Color darkHeaderClr = Colors.grey[800];

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    primaryColor: primaryClr,
  );
}

TextStyle get headingTextStyle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
  );
}

TextStyle get titleTextStle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subTitleTextStle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 18,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700]),
  );
}

TextStyle get bodyTextStyle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

get colorIcon {
  return Get.isDarkMode ? Colors.white : Colors.black;
}

TextStyle get body2TextStyle {
  return GoogleFonts.poppins(
    textStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[600]),
  );
}
