import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/evaluations/statistics/page.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/generated/i18n.dart';
// import 'package:filcnaplo/ui/empty.dart';

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
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: app.tabState.evaluations.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _menuKeyGrades = GlobalKey();

    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            indicatorColor: app.settings.appColor,
            onTap: (value) {
              app.tabState.evaluations.index = value;
              _tabController.animateTo(value);
              app.sync.updateCallback();
              app.storage.storage.update("tabs", {"evaluations": value});
            },
            tabs: <Widget>[
              SizedBox(
                height: 46.0,
                child: FlatButton(
                  key: _menuKeyGrades,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                [
                                  I18n.of(context).evaluationsMidYear,
                                  I18n.of(context).evaluationsQYear,
                                  I18n.of(context).evaluations2qYear,
                                  I18n.of(context).evaluationsHalfYear,
                                  I18n.of(context).evaluations3qYear,
                                  I18n.of(context).evaluations4qYear,
                                  I18n.of(context).evaluationsEndYear,
                                ][app.selectedEvalPage.clamp(0, 6)]
                                    .replaceAll(". ", "."),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: app.settings.theme.textTheme
                                        .bodyText1.color),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    if (_tabController.index == 0) {
                      showMenu(
                        context: context,
                        position: () {
                          Offset pos = _getPosition(_menuKeyGrades);
                          return RelativeRect.fromLTRB(0, pos.dy, pos.dx, 0);
                        }(),
                        items: () {
                          List<PopupMenuItem> items = [];
                          List<String> types = [];
                          Map<String, String> evalTypes = {
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
                          };

                          app.user.sync.evaluation.data[0]
                              .forEach((evaluation) {
                            if (!types.contains(evaluation.type.name)) {
                              types.add(evaluation.type.name);
                            }
                          });

                          for (int i = 0; i < evalTypes.keys.length; i++) {
                            String type = evalTypes.keys.toList()[i];

                            if (types.contains(type)) {
                              items.add(PopupMenuItem(
                                value: i,
                                child: Text(evalTypes[type]),
                              ));
                            }
                          }

                          return items;
                        }(),
                      ).then((value) {
                        if (value != null)
                          setState(() => app.selectedEvalPage = value);
                        widget.callback();
                      });
                    } else {
                      app.tabState.evaluations.index = 0;
                      _tabController.animateTo(0);
                      app.sync.updateCallback();
                      app.storage.storage.update("tabs", {"evaluations": 0});
                    }
                  },
                ),
              ),
              // Tab(
              //   child: Text(capital(I18n.of(context).evaluationsAll)),
              // ),
              Tab(
                child: Text(
                  capital(I18n.of(context).evaluationsSubjects),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
              Tab(
                child: Text(
                  capital(I18n.of(context).evaluationsStatistics),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
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
                      setState(() {});
                    }
                  },
                  child: Scrollbar(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: widget._gradeTiles.length > 0
                          ? widget._gradeTiles
                          : <Widget>[
                              Empty(title: I18n.of(context).emptyGrades),
                            ],
                    ),
                  ),
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
                      setState(() {});
                    }
                  },
                  child: Scrollbar(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
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
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: widget._subjectTiles,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Statistics
                StatisticsPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Offset _getPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final position = renderBox.localToGlobal(Offset.zero);
  return position;
}
