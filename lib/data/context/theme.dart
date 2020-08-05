import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeContext {
  static final Map<String, Color> colors = {
    "blue": Colors.blue[700],
    "default": Colors.teal[600],
    "green": Colors.green[700],
    "lime": Colors.lightGreen,
    "yellow": Colors.yellow[700],
    "orange": Colors.orange[700],
    "red": Colors.red[700],
    "pink": Colors.pink[700],
    "purple": Colors.purple[700],
  };

  List<Color> evalColors = [
    Colors.red,
    Colors.amber[700],
    Colors.yellow[600],
    Colors.lime[600],
    Colors.green,
  ];

  static Color lightTextColor = Colors.grey[700];
  static TextTheme lightText = TextTheme(
      headline6: TextStyle(color: lightTextColor, fontSize: 20.0),
      bodyText1: TextStyle(color: lightTextColor),
      bodyText2: TextStyle(color: lightTextColor));

  static Color lightBackground = Colors.white;

  ThemeData light(Color appColor) => ThemeData(
        brightness: Brightness.light,
        accentColor: appColor,
        backgroundColor: lightBackground,
        textTheme: lightText,
        primaryTextTheme: lightText,
        iconTheme: IconThemeData(color: lightTextColor),
        fontFamily: GoogleFonts.openSans().fontFamily,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[200],
          actionTextColor: appColor,
          contentTextStyle: TextStyle(color: lightTextColor),
        ),
        appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: lightText,
            iconTheme: IconThemeData(color: lightTextColor)),
      );

  ThemeData tinted() => ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.teal[600],
        backgroundColor: Color(0xFF273d38),
        scaffoldBackgroundColor: Color(0xFF1c2d2a),
        textTheme: darkText,
        iconTheme: IconThemeData(color: darkTextColor),
        fontFamily: GoogleFonts.openSans().fontFamily,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF273d38),
          actionTextColor: Colors.teal[600],
          contentTextStyle: TextStyle(color: darkTextColor),
        ),
        appBarTheme: AppBarTheme(
            color: Color(0xFF273d38),
            textTheme: darkText,
            iconTheme: IconThemeData(color: darkTextColor)),
      );

  static Color darkTextColor = Colors.grey[100];
  static TextTheme darkText = TextTheme(
      headline6: TextStyle(color: darkTextColor, fontSize: 20.0),
      bodyText1: TextStyle(color: darkTextColor),
      bodyText2: TextStyle(color: darkTextColor));

  static Color darkBackground = Color(0xff36393f);
  static Color blackBackground = Color(0xff18191c);

  ThemeData dark(Color appColor, int backgroundColor) => ThemeData(
        brightness: Brightness.dark,
        accentColor: appColor,
        backgroundColor:
            backgroundColor == 0 ? blackBackground : darkBackground,
        textTheme: darkText,
        primaryTextTheme: darkText,
        iconTheme: IconThemeData(color: Colors.grey[100]),
        fontFamily: GoogleFonts.openSans().fontFamily,
        scaffoldBackgroundColor:
            backgroundColor == 0 ? Colors.black : Color(0xff292b2f),
        snackBarTheme: SnackBarThemeData(
          backgroundColor:
              backgroundColor == 0 ? blackBackground : darkBackground,
          actionTextColor: appColor,
          contentTextStyle: TextStyle(color: darkTextColor),
        ),
        appBarTheme: AppBarTheme(
            color: backgroundColor == 0 ? blackBackground : darkBackground,
            textTheme: darkText),
      );
}
