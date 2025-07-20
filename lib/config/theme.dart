import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData themeConfig = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),

  appBarTheme: AppBarTheme(
    color: Color(0xFF3077E3),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 23,
      fontWeight: FontWeight.w500,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsetsGeometry.directional(top: 10, bottom: 10),
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF3077E3),
      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: EdgeInsetsGeometry.directional(top: 10, bottom: 10),
      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(width: 1.5, color: Color(0xFF3077E3)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.all(10),
    hintStyle: TextStyle(
      fontSize: 14,
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFF3077E3), width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.black, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFF3077E3), width: 1.5),
    ),
  ),
);
