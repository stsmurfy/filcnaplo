import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/about/privacy.dart';
import 'package:filcnaplo/ui/pages/about/supporters.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(I18n.of(context).aboutTitle)),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Hero Logo
              Container(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Image.asset("assets/icon.png"),
                width: 164,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Filc Napló", style: TextStyle(fontSize: 32.0)),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      app.currentAppVersion,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.0),

              AboutButton(
                text: I18n.of(context).aboutPrivacy,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AboutPrivacy());
                },
              ),
              AboutButton(
                text: I18n.of(context).aboutLicenses,
                onPressed: () {
                  showLicensePage(
                    context: context,
                    applicationName: "Filc Napló",
                    applicationVersion: app.currentAppVersion,
                    applicationIcon: Container(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset("assets/icon.png")),
                  );
                },
              ),
              AboutButton(
                text: I18n.of(context).aboutSupporters,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => AboutSupporters()),
                  );
                },
              ),
              AboutButton(
                icon: FeatherIcons.github,
                text: "Github",
                onPressed: () {
                  launch("https://github.com/filcnaplo/filcnaplo");
                },
              ),
              AboutButton(
                icon: FeatherIcons.globe,
                text: "filcnaplo.hu",
                onPressed: () {
                  launch("https://www.filcnaplo.hu/");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  AboutButton({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon != null
              ? Padding(padding: EdgeInsets.only(right: 8.0), child: Icon(icon))
              : Container(),
          Text(text, style: TextStyle(fontSize: 18.0))
        ],
      ),
      onPressed: onPressed,
    );
  }
}
