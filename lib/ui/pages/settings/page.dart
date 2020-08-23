import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/settings/debug.dart';
import 'package:filcnaplo/ui/pages/settings/notification.dart';
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              leading: BackButton(),
              title: Text(I18n.of(context).settingsTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),

            SettingTile(
                title: I18n.of(context).settingsGeneralTitle,
                icon: FeatherIcons.settings,
                page: GeneralSettings()),

            SettingTile(
                title: I18n.of(context).settingsAppearanceTitle,
                icon: app.settings.theme.brightness == Brightness.light
                    ? FeatherIcons.sun
                    : FeatherIcons.moon,
                page: AppearanceSettings()),

            SettingTile(
                title: I18n.of(context).settingsPrivacyTitle,
                icon: FeatherIcons.lock,
                page: PrivacySettings()),

            SettingTile(
                title: I18n.of(context).settingsNotificationsTitle,
                icon: FeatherIcons.bell,
                page: NotificationSettings()),

            // Debug options // Only for debug
            app.debugVersion
                ? SettingTile(
                    title: I18n.of(context).settingsDebugTitle,
                    icon: FeatherIcons.terminal,
                    page: DebugSettings())
                : Container(),

            Spacer(),

            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 8, 4),
              child: Row(
                children: <Widget>[
                  Text(
                    "Filc Napló " + app.currentAppVersion,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(FeatherIcons.info, color: app.settings.appColor),
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

class SettingTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;

  SettingTile({this.title, this.icon, this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0.0),
          title: Text(capital(title)),
          leading: Icon(icon, color: app.settings.appColor),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
