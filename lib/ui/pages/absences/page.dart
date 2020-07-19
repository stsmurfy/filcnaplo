import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/absences/tabs.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/ui/pages/absences/absence/builder.dart';
import 'package:filcnaplo/ui/pages/absences/delay/builder.dart';
import 'package:filcnaplo/ui/pages/absences/miss/builder.dart';

class AbsencesPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  AbsencesPage(this._scaffoldKey);

  @override
  _AbsencesPageState createState() => _AbsencesPageState(this._scaffoldKey);
}

class _AbsencesPageState extends State<AbsencesPage>
    with SingleTickerProviderStateMixin {
  AbsenceBuilder _absenceBuilder;
  DelayBuilder _delayBuilder;
  MissBuilder _missBuilder;

  _AbsencesPageState(_scaffoldKey) {
    this._absenceBuilder = AbsenceBuilder();
    this._delayBuilder = DelayBuilder();
    this._missBuilder = MissBuilder();
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    _absenceBuilder.build();
    _delayBuilder.build();
    _missBuilder.build();
  }

  @override
  Widget build(BuildContext context) {
    buildPage();

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(18.0, 42.0, 18.0, 12.0),
            child: Row(
              children: <Widget>[
                Text(
                  I18n.of(context).absenceTitle,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                GestureDetector(
                  child: app.user.profileIcon,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccountPage()));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: AbsenceTabs(
              widget._scaffoldKey,
              _absenceBuilder.absenceTiles,
              _delayBuilder.delayTiles,
              _missBuilder.missTiles,
              updateCallback,
            ),
          ),
        ],
      ),
    );
  }
}
