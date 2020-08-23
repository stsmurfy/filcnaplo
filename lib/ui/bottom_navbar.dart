import 'package:filcnaplo/data/context/theme.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';

class BottomNavbar extends StatelessWidget {
  final Function onTap;

  BottomNavbar(this.onTap);

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        // Home Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.search,
            ),
          ),
          label: "",
        ),

        // Evaluations Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.bookmark,
            ),
          ),
          label: "",
        ),

        // Timetable Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.calendar,
            ),
          ),
          label: "",
        ),
        // Messages Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.messageSquare,
            ),
          ),
          label: "",
        ),
        // Absences Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.slash,
            ),
          ),
          label: "",
        ),
      ],
      currentIndex: app.selectedPage,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      selectedIconTheme: IconThemeData(color: app.settings.appColor),
      unselectedIconTheme:
          IconThemeData(color: app.settings.theme.textTheme.bodyText1.color),
      type: BottomNavigationBarType.fixed,
      backgroundColor: app.settings.theme.backgroundColor.value ==
              ThemeContext().tinted().backgroundColor.value
          ? Color(0xFF101C19)
          : app.settings.theme.brightness == Brightness.dark
              ? app.settings.backgroundColor == 0
                  ? Colors.black
                  : Color(0xff18191c)
              : Colors.white,
      onTap: this.onTap,
    );
  }
}
