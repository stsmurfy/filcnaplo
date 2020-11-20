import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/account_button.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:filcnaplo/ui/pages/evaluations/dial.dart';
import 'package:filcnaplo/ui/pages/evaluations/statistics/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/generated/i18n.dart';

class EvaluationTabs extends StatefulWidget {
  final Function callback;
  final _gradeTiles;
  final _subjectTiles;
  final _scaffoldKey;

  EvaluationTabs(
      this._scaffoldKey, this._gradeTiles, this._subjectTiles, this.callback);

  @override
  _EvaluationTabsState createState() => _EvaluationTabsState();
}

class _EvaluationTabsState extends State<EvaluationTabs>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final _refreshKeyGrades = GlobalKey<RefreshIndicatorState>();
  final _refreshKeySubjects = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    _tabController.addListener(() => widget.callback());
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> types = [];

    app.user.sync.evaluation.data[0].forEach((evaluation) {
      if (!types.contains(evaluation.type.name)) {
        types.add(evaluation.type.name);
      }
    });

    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? EvaluationsDial(
              (app.evalSortBy / 2).floor(),
              app.evalSortBy % 2 == 1,
              onSelect: (int selected) {
                int newVal = 4 - selected * 2;
                bool changed = newVal != app.evalSortBy;

                app.evalSortBy = newVal + (changed ? 0 : 1);
                widget.callback();
              },
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              forceElevated: true,
              title: Text(
                I18n.of(context).evaluationTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: <Widget>[
                DebugButton(DebugViewClass.evalutaions),
                AccountButton()
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  _tabController.animateTo(value);
                  widget.callback();
                },
                labels: [
                  CustomLabel(
                    title: types.length == 1
                        ? capital(I18n.of(context).evaluationsMidYear)
                        : null,
                    dropdown: types.length > 1
                        ? CustomDropdown(
                            values: {
                              "evkozi_jegy_ertekeles":
                                  I18n.of(context).evaluationsMidYear,
                              "I_ne_jegy_ertekeles":
                                  I18n.of(context).evaluationsQYear,
                              "II_ne_jegy_ertekeles":
                                  I18n.of(context).evaluations2qYear,
                              "felevi_jegy_ertekeles":
                                  I18n.of(context).evaluationsHalfYear,
                              "III_ne_jegy_ertekeles":
                                  I18n.of(context).evaluations3qYear,
                              "IV_ne_jegy_ertekeles":
                                  I18n.of(context).evaluations4qYear,
                              "evvegi_jegy_ertekeles":
                                  I18n.of(context).evaluationsEndYear,
                            },
                            check: (String type) {
                              return types.contains(type);
                            },
                            callback: (value) {
                              setState(() => app.selectedEvalPage = value);
                              widget.callback();
                            },
                            initialValue: app.selectedEvalPage,
                          )
                        : null,
                  ),
                  CustomLabel(
                      title: capital(I18n.of(context).evaluationsSubjects)),
                  CustomLabel(
                      title: capital(I18n.of(context).evaluationsStatistics)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Grades
            RefreshIndicator(
              key: _refreshKeyGrades,
              onRefresh: () async {
                if (!await app.user.sync.evaluation.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorEvaluations,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  if (mounted) setState(() {});
                }
              },
              child: widget._gradeTiles.length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                          padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 64.0),
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: widget._gradeTiles),
                    )
                  : Empty(title: I18n.of(context).emptyGrades),
            ),

            // Subjects
            RefreshIndicator(
              key: _refreshKeySubjects,
              onRefresh: () async {
                if (!await app.user.sync.evaluation.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorEvaluations,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                  setState(() {});
                }
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Row(
                      children: <Widget>[
                        Icon(FeatherIcons.book),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.0),
                          child: Icon(FeatherIcons.users),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.0),
                          child: Icon(FeatherIcons.trendingUp),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoScrollbar(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: widget._subjectTiles,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Statistics
            StatisticsPage(),
          ],
        ),
      ),
    );
  }
}
