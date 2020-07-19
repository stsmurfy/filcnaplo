import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/settings/behavior.dart';
import 'package:filcnaplo/ui/pages/settings/debug.dart';
import 'package:filcnaplo/ui/pages/settings/notification.dart';
import 'package:flutter/material.dart';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/about/page.dart';
import 'package:filcnaplo/ui/pages/settings/appearance.dart';
import 'package:filcnaplo/ui/pages/settings/general.dart';
import 'package:filcnaplo/ui/pages/settings/privacy.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).settingsTitle),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(I18n.of(context).settingsGeneralTitle),
                leading: Icon(FeatherIcons.settings),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GeneralSettings()));
                }),

            ListTile(
              title: Text(I18n.of(context).settingsAppearanceTitle),
              leading: Icon(app.settings.theme.brightness == Brightness.light
                  ? FeatherIcons.sun
                  : FeatherIcons.moon),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppearanceSettings()));
              },
            ),

            ListTile(
                title: Text(I18n.of(context).settingsPrivacyTitle),
                leading: Icon(FeatherIcons.lock),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacySettings()));
                }),

            ListTile(
                title: Text(I18n.of(context).settingsNotificationsTitle),
                leading: Icon(FeatherIcons.bell),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationSettings()));
                }),

            ListTile(
                title: Text(I18n.of(context).settingsBehaviorTitle),
                leading: Icon(FeatherIcons.sliders),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BehaviorSettings()));
                }),

            // Debug options // Only for debug
            app.debugVersion
                ? ListTile(
                    title: Text(I18n.of(context).settingsDebugTitle),
                    leading: Icon(FeatherIcons.terminal),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DebugSettings()));
                    })
                : Container(),

            Spacer(),

            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 8, 4),
              child: Row(
                children: <Widget>[
                  Text("Filc Napló " + app.currentAppVersion,
                      style: TextStyle(fontSize: 16.0)),
                  Spacer(),
                  IconButton(
                    icon: Icon(FeatherIcons.info),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
