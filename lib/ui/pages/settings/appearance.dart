import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AppearanceSettings extends StatefulWidget {
  @override
  _AppearanceSettingsState createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(I18n.of(context).settingsAppearanceTitle)),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            // Theme Title
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                capital(I18n.of(context).settingsAppearanceTheme),
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            // Theme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Light theme
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 42.0,
                        width: 42.0,
                        margin: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Theme.of(context).brightness == Brightness.light
                          ? Container(
                              height: 64.0,
                              width: 64.0,
                              alignment: Alignment.center,
                              child: Icon(FeatherIcons.check),
                            )
                          : Container(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      app.settings.theme =
                          ThemeContext().light(app.settings.appColor);

                      DynamicTheme.of(context).setThemeData(app.settings.theme);
                    });

                    app.storage.storage.update("settings", {
                      "theme": "light",
                    });
                  },
                ),

                // Tinted Theme
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 42.0,
                        width: 42.0,
                        margin: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      app.settings.theme.backgroundColor.value ==
                              ThemeContext()
                                  .tinted(app.settings.appColor)
                                  .backgroundColor
                                  .value
                          ? Container(
                              height: 64.0,
                              width: 64.0,
                              alignment: Alignment.center,
                              child: Icon(FeatherIcons.check),
                            )
                          : Container(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      app.settings.theme =
                          ThemeContext().tinted(app.settings.appColor);

                      DynamicTheme.of(context).setThemeData(app.settings.theme);
                    });

                    app.storage.storage.update("settings", {
                      "theme": "tinted",
                    });
                  },
                ),

                // Dark Theme
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 42.0,
                        width: 42.0,
                        margin: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      app.settings.theme.backgroundColor.value !=
                                  ThemeContext()
                                      .tinted(app.settings.appColor)
                                      .backgroundColor
                                      .value &&
                              Theme.of(context).brightness == Brightness.dark &&
                              app.settings.backgroundColor == 1
                          ? Container(
                              height: 64.0,
                              width: 64.0,
                              alignment: Alignment.center,
                              child: Icon(FeatherIcons.check),
                            )
                          : Container(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      app.settings.backgroundColor = 1;
                      app.settings.theme = ThemeContext().dark(
                          app.settings.appColor, app.settings.backgroundColor);

                      DynamicTheme.of(context).setThemeData(app.settings.theme);
                    });

                    app.storage.storage.update("settings", {
                      "theme": "dark",
                      "background_color": 1,
                    });
                  },
                ),

                // Black theme
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 42.0,
                        width: 42.0,
                        margin: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      app.settings.theme.backgroundColor.value !=
                                  ThemeContext()
                                      .tinted(app.settings.appColor)
                                      .backgroundColor
                                      .value &&
                              Theme.of(context).brightness == Brightness.dark &&
                              app.settings.backgroundColor == 0
                          ? Container(
                              height: 64.0,
                              width: 64.0,
                              alignment: Alignment.center,
                              child: Icon(FeatherIcons.check),
                            )
                          : Container(),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      app.settings.backgroundColor = 0;
                      app.settings.theme = ThemeContext().dark(
                          app.settings.appColor, app.settings.backgroundColor);

                      DynamicTheme.of(context).setThemeData(app.settings.theme);
                    });

                    app.storage.storage.update("settings", {
                      "theme": "dark",
                      "background_color": 0,
                    });
                  },
                ),
              ],
            ),

            // App Color

            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                capitalize(I18n.of(context).settingsAppearanceColor),
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              children: () {
                List<Widget> colorButtons = [];

                for (int i = 0;
                    i < ThemeContext.colors.values.toList().length;
                    i++) {
                  Color color = ThemeContext.colors.values.toList()[i];

                  colorButtons.add(GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 32.0,
                          width: 32.0,
                          margin: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(99.0),
                          ),
                        ),
                        app.settings.appColor == color
                            ? Container(
                                alignment: Alignment.center,
                                width: 56.0,
                                height: 56.0,
                                child: Container(
                                  width: 24.0,
                                  height: 24.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    width: 18.0,
                                    height: 18.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        app.settings.appColor = color;

                        if (Theme.of(context).brightness == Brightness.light)
                          app.settings.theme =
                              ThemeContext().light(app.settings.appColor);
                        else
                          app.settings.theme = ThemeContext().dark(
                              app.settings.appColor,
                              app.settings.backgroundColor);

                        DynamicTheme.of(context)
                            .setThemeData(app.settings.theme);
                      });

                      app.storage.storage.update("settings", {
                        "app_color": ThemeContext.colors.keys.toList()[i],
                      });

                      app.storage.storage.update("settings", {
                        "theme":
                            Theme.of(context).brightness == Brightness.light
                                ? "light"
                                : "dark",
                      });
                    },
                  ));
                }

                // add ghost buttons to pad alignment
                for (int i = 0; i < 3; i++) {
                  colorButtons.add(SizedBox(height: 56.0, width: 56.0));
                }

                return colorButtons;
              }(),
            ),

            // Evaluation Colors

            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                capitalize(I18n.of(context).settingsAppearanceEvalColors),
                style: TextStyle(fontSize: 18.0),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  EvaluationColor(5, onChanged: changeColor),
                  EvaluationColor(4, onChanged: changeColor),
                  EvaluationColor(3, onChanged: changeColor),
                  EvaluationColor(2, onChanged: changeColor),
                  EvaluationColor(1, onChanged: changeColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeColor(Color color, int value) {
    setState(() => app.theme.evalColors[value] = color);

    app.storage.storage.update("eval_colors", {
      "color" + (value + 1).toString():
          "#" + color.toString().substring(10, 16),
    });
    
    DynamicTheme.of(context).setThemeData(app.settings.theme);
  }
}

class EvaluationColor extends StatelessWidget {
  final int value;
  final Function onChanged;

  EvaluationColor(this.value, {this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 46.0,
        height: 46.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: app.theme.evalColors[value - 1],
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.0,
              fontFamily: "sans",
              fontWeight: FontWeight.w500,
              color: textColor(app.theme.evalColors[value - 1]),
            ),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(I18n.of(context).settingsAppearancePickColor),
            content: MaterialColorPicker(
              onColorChange: (Color color) => onChanged(color, value - 1),
              selectedColor: app.theme.evalColors[value - 1],
              circleSize: 54,
              shrinkWrap: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  I18n.of(context).dialogOk,
                  style: TextStyle(color: app.settings.appColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
