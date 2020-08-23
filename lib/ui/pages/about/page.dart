import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/about/privacy.dart';
import 'package:filcnaplo/ui/pages/about/supporters/page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF236A5B),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 32.0, right: 12.0),
              child: IconButton(
                icon: Icon(FeatherIcons.x, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Spacer(),
            // Hero Logo
            Container(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Image.asset("assets/icon.png"),
              width: 164,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Filc Napló",
                    style: TextStyle(fontSize: 32.0, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    app.currentAppVersion,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.0),

            AboutButton(
              icon: FeatherIcons.lock,
              text: I18n.of(context).aboutPrivacy,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AboutPrivacy());
              },
            ),
            AboutButton(
              icon: FeatherIcons.award,
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
              icon: FeatherIcons.dollarSign,
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
            Spacer(),
          ],
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
    return Container(
      width: 250.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: ListTile(
            leading: icon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(icon, color: Colors.white))
                : Container(),
            title: Text(text,
                style: TextStyle(fontSize: 18.0, color: Colors.white))),
        onPressed: onPressed,
      ),
    );
  }
}
