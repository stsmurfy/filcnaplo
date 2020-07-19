import 'package:filcnaplo/ui/pages/planner/homeworks/builder.dart';
import 'package:filcnaplo/ui/pages/planner/tabs.dart';
import 'package:filcnaplo/ui/pages/planner/tests/builder.dart';
import 'package:flutter/material.dart';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/data/context/app.dart';

class PlannerPage extends StatefulWidget {
  final _scaffoldKey;

  PlannerPage(this._scaffoldKey);

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  HomeworkBuilder homeworkBuilder;
  TestBuilder testBuilder;

  @override
  void initState() { 
    super.initState();
    
    homeworkBuilder = HomeworkBuilder(updateCallback);
    testBuilder = TestBuilder();
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
                  I18n.of(context).plannerTitle,
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
            child: PlannerTabs(
              widget._scaffoldKey,
              homeworkBuilder.homeworkTiles,
              testBuilder.testTiles,
              callback: updateCallback,
            ),
          ),
        ],
      ),
    );
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    homeworkBuilder.build();
    testBuilder.build();
  }
}
