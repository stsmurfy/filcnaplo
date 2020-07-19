import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
//import 'package:filcnaplo/data/context/app.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class PrivacySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(I18n.of(context).settingsPrivacyTitle),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(FeatherIcons.eye),
              title: Text(I18n.of(context).settingsPrivacySeen),
              trailing: Switch(
                value: false,
                onChanged: (bool value) {
                  // magic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
