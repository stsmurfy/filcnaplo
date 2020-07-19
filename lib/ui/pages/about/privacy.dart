import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';

class AboutPrivacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: app.settings.theme.backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.only(top: 18.0, bottom: 4.0),
        margin: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                    "A Filc Napló alkalmazás arra való, hogy a KRÉTA szervereiről lekérje iskolai adataidat, és azokat egy" +
                        "jól használható felületen keresztül megjelenítse. Ezek az adatok csakis az alkalmazás és a KRÉTA szerverei " +
                        "között kerülnek továbbításra, a Filc saját szerverére nem. Felhasználási adatot vagy statisztikát sem gyűjt " +
                        "az alkalmazás, semmit sem továbbítunk a saját szerverünkre. Adataid annyira vannak biztonságban, mint a " +
                        "hivatalos KRÉTA alkalmazás esetén, tehát ha a telefonodon nem végeztél jelentős beavatkozást (root-olás, " +
                        "saját titkosítási kulcs telepítése), akkor az adataid biztonságban vannak. Az alkalmazás a lekért adatokat " +
                        "telefonodon titkosítás nélkül tárolja, aki hozzáfér a telefonod tárhelyéhez közvetlenül az ezeket is " +
                        "kiolvashatja. Ezért nem vállalunk felelősséget. Mivel nem kezelünk közvetlenül személyes adatokat, csupán " +
                        "egy passzív szolgáltatást nyújtunk azok lekéréséhez megjelenítéséhez, nem neveztünk ki adatvédelmi " +
                        "tisztviselőt, és gyűjtött adat hiányában azok módosítását vagy törlését sem kérheted. Az alkalmazás, mint " +
                        "minden másik, ami fel van töltve a Google Play szolgáltatásba, használja a Google Play Szolgáltatásokat. " +
                        "Erre a Google adatvédelmi irányelvei és szerződési feltételei érvényesek, amiket a telefonod beállításakor " +
                        "el kellet olvasnod és fogadnod. Ezek itt olvashatók: https://policies.google.com/",
                    style: TextStyle(fontSize: 14.0)),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text(
                  I18n.of(context).dialogOk,
                  style: TextStyle(color: app.settings.appColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
