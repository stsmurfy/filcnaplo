import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class BehaviorSettings extends StatefulWidget {
  @override
  _BehaviorSettingsState createState() => _BehaviorSettingsState();
}

class _BehaviorSettingsState extends State<BehaviorSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(I18n.of(context).settingsBehaviorTitle),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(FeatherIcons.code),
              title: Text(I18n.of(context).settingsBehaviorRenderHTML),
              trailing: Switch(
                value: app.settings.renderHtml,
                onChanged: (bool value) {
                  setState(() => app.settings.renderHtml = value);

                  app.storage.storage.update("settings", {
                    "render_html": value ? 1 : 0,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
