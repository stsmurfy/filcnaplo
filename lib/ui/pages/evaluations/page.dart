import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/builder.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/builder.dart';
import 'package:filcnaplo/ui/pages/evaluations/tabs.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';

class EvaluationsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  EvaluationsPage(this._scaffoldKey);

  @override
  _EvaluationsPageState createState() =>
      _EvaluationsPageState(this._scaffoldKey);
}

class _EvaluationsPageState extends State<EvaluationsPage> {
  GradeBuilder _gradeBuilder;
  SubjectBuilder _subjectBuilder;

  _EvaluationsPageState(_scaffoldKey) {
    this._gradeBuilder = GradeBuilder();
    this._subjectBuilder = SubjectBuilder();
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    _gradeBuilder.build(sortBy: app.evalSortBy);
    _subjectBuilder.build();
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
                  I18n.of(context).evaluationTitle,
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
            child: EvaluationTabs(
              widget._scaffoldKey,
              _gradeBuilder.gradeTiles,
              _subjectBuilder.subjectTiles,
              updateCallback,
            ),
          ),
        ],
      ),
    );
  }
}
