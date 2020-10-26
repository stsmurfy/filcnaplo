import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/home/page.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  Map<String, String> languages = {
    "en_US": "English",
    "de_DE": "Deutsch",
    "hu_HU": "Magyar",
  };

  @override
  Widget build(BuildContext context) {
    List<String> pages = [
      I18n.of(context).drawerHome,
      I18n.of(context).drawerEvaluations,
      I18n.of(context).drawerTimetable,
      I18n.of(context).drawerMessages,
      I18n.of(context).drawerAbsences
    ];
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            AppBar(
              centerTitle: true,
              leading: BackButton(),
              title: Text(I18n.of(context).settingsGeneralTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ListTile(
              leading: Icon(FeatherIcons.globe),
              title: Text(I18n.of(context).settingsGeneralLanguage),
              trailing: DropdownButton(
                underline: Container(),
                value:
                ['hu_HU', 'en_US', 'de_DE'].contains(app.settings.language)
                    ? app.settings.language
                    : app.settings.deviceLanguage,
                items: ['hu_HU', 'en_US', 'de_DE'].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(languages[value]),
                  );
                }).toList(),
                onChanged: (String language) {
                  setState(() {
                    app.settings.language = language;
                    I18n.onLocaleChanged(Locale(
                      language.split("_")[0],
                      language.split("_")[1],
                    ));
                  });

                  app.storage.storage.update("settings", {
                    "language": language,
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.file),
              title: Text(I18n.of(context).settingsGeneralStartPage),
              trailing: DropdownButton(
                underline: Container(),
                value: app.settings.defaultPage,
                items: [0, 1, 2, 3, 4].map((int value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(pages[value]),
                  );
                }).toList(),
                onChanged: (int newDefaultPage) {
                  setState(() {
                    app.settings.defaultPage = newDefaultPage;
                  });
                  app.storage.storage
                      .update("settings", {"default_page": newDefaultPage});
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.topLeft,
              child: Text(
                I18n.of(context).settingsGeneralCustomizeHome.toUpperCase(),
                style: TextStyle(
                  fontSize: 15.0,
                  letterSpacing: .7,
                ),
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.bookmark),
              title: Text(I18n.of(context).evaluationTitle),
              trailing: Switch(
                value: app.settings.homeShowEvaluations,
                onChanged: (bool value) {
                  setState(() => app.settings.homeShowEvaluations = value);
                  app.sync.updateCallback();
                  app.storage.storage.update("settings", {
                    "home_show_evaluations": value ? 1 : 0,
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.home),
              title: Text(I18n.of(context).homeworkTitle),
              trailing: Switch(
                value: app.settings.homeShowHomeworks,
                onChanged: (bool value) {
                  setState(() => app.settings.homeShowHomeworks = value);
                  app.sync.updateCallback();
                  app.storage.storage.update("settings", {
                    "home_show_homeworks": value ? 1 : 0,
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.messageSquare),
              title: Text(I18n.of(context).messageTitle),
              trailing: Switch(
                value: app.settings.homeShowMessages,
                onChanged: (bool value) {
                  setState(() => app.settings.homeShowMessages = value);
                  app.sync.updateCallback();
                  app.storage.storage.update("settings", {
                    "home_show_messages": value ? 1 : 0,
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.slash),
              title: Text(I18n.of(context).absenceTitle),
              trailing: Switch(
                value: app.settings.homeShowAbsences,
                onChanged: (bool value) {
                  setState(() => app.settings.homeShowAbsences = value);
                  app.sync.updateCallback();
                  app.storage.storage.update("settings", {
                    "home_show_absences": value ? 1 : 0,
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(FeatherIcons.clock),
              title: Text(I18n.of(context).eventUpcoming),
              trailing: Switch(
                value: app.settings.homeShowUpcoming,
                onChanged: (bool value) {
                  setState(() => app.settings.homeShowUpcoming = value);
                  app.sync.updateCallback();
                  app.storage.storage.update("settings", {
                    "home_show_upcoming": value ? 1 : 0,
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
