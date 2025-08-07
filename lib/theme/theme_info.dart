import 'package:flutter/material.dart';

class ThemeInfo {
  var themeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue[50]!,
      primary: Colors.blue[900],
    ),
    iconTheme: IconThemeData(color: Colors.black54),
    menuTheme: MenuThemeData(
      style: MenuStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
