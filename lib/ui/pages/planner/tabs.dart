//import 'package:flutter/gestures.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/frame.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
//import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class PlannerTabs extends StatefulWidget {
  final _scaffoldKey;
  final homeworkTiles;
  final testTiles;
  final Function callback;

  PlannerTabs(
    this._scaffoldKey,
    this.homeworkTiles,
    this.testTiles, {
    this.callback,
  });

  @override
  _PlannerTabsState createState() => _PlannerTabsState();
}

class _PlannerTabsState extends State<PlannerTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyTimetable = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyHomeworks = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyTests = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;

  bool showPastTests = false;
  bool showPastHomeworks = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: app.tabState.timetable.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey _menuKeyTimetable = GlobalKey();

    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            labelPadding: EdgeInsets.zero,
            indicatorColor: app.settings.appColor,
            controller: _tabController,
            onTap: (value) {
              app.tabState.timetable.index = value;
              _tabController.animateTo(value);
              app.sync.updateCallback();
              app.storage.storage.update("tabs", {"timetable": value});
            },
            tabs: [
              // FlatButton(
              //   key: _menuKeyTimetable,
              //   padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     children: [
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Expanded(
              //               child: Text(
              //                 [
              //                   capital(I18n.of(context).messageDrawerInbox),
              //                   capital(I18n.of(context).messageDrawerSent),
              //                   capital(I18n.of(context).messageDrawerTrash),
              //                 ][app.selectedTimetablePage],
              //                 maxLines: 1,
              //                 overflow: TextOverflow.ellipsis,
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                     color: app.settings.theme.textTheme.bodyText1
              //                         .color),
              //               ),
              //             ),
              //             Icon(Icons.arrow_drop_down),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              //   onPressed: () {
              //     if (_tabController.index == 0) {
              //       showMenu(
              //         context: context,
              //         position: () {
              //           Offset pos = _getPosition(_menuKeyTimetable);
              //           return RelativeRect.fromLTRB(0, pos.dy, pos.dx, 0);
              //         }(),
              //         items: [
              //           PopupMenuItem(
              //             value: 1,
              //             child: Text(
              //                 capital(I18n.of(context).messageDrawerInbox)),
              //           ),
              //           PopupMenuItem(
              //             value: 2,
              //             child:
              //                 Text(capital(I18n.of(context).messageDrawerSent)),
              //           ),
              //           PopupMenuItem(
              //             value: 3,
              //             child: Text(
              //                 capital(I18n.of(context).messageDrawerTrash)),
              //           ),
              //         ],
              //       ).then((value) {
              //         if (value != null)
              //           setState(() => app.selectedTimetablePage = value - 1);
              //       });
              //     } else {
              //       app.tabState.timetable.index = 0;
              //       _tabController.animateTo(0);
              //       app.sync.updateCallback();
              //       app.storage.storage.update("tabs", {"timetable": 0});
              //     }
              //   },
              // ),
              Tab(
                child: Text(
                  capital(I18n.of(context).plannerTimetable),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
              Tab(
                child: Text(
                  capital(I18n.of(context).plannerHomework),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
              Tab(
                child: Text(
                  capital(I18n.of(context).plannerTests),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Timetable
                RefreshIndicator(
                  key: _refreshKeyTimetable,
                  onRefresh: () async {
                    if (!await app.user.sync.timetable.sync()) {
                      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          I18n.of(context).errorMessages,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      widget.callback();
                    }
                  },
                  child: TimetableFrame(),
                ),

                // Homeworks
                RefreshIndicator(
                  key: _refreshKeyHomeworks,
                  onRefresh: () async {
                    if (!await app.user.sync.homework.sync()) {
                      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          I18n.of(context).errorMessages,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      widget.callback();
                    }
                  },
                  child: Scrollbar(
                    child: ListView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: <Widget>[
                        widget.homeworkTiles[0].length > 0
                            ? Column(children: widget.homeworkTiles[0])
                            : Empty(title: I18n.of(context).emptyHomework),
                        FlatButton(
                          onPressed: () => setState(
                              () => showPastHomeworks = !showPastHomeworks),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(I18n.of(context).homeworkPast)),
                              Icon(
                                showPastHomeworks
                                    ? FeatherIcons.chevronUp
                                    : FeatherIcons.chevronDown,
                              ),
                            ],
                          ),
                        ),
                        showPastHomeworks
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: widget.homeworkTiles[1].length > 0
                                    ? Column(children: widget.homeworkTiles[1])
                                    : Empty(
                                        title:
                                            I18n.of(context).emptyPastHomework,
                                      ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),

                // Tests
                RefreshIndicator(
                  key: _refreshKeyTests,
                  onRefresh: () async {
                    if (!await app.user.sync.test.sync()) {
                      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          I18n.of(context).errorMessages,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      widget.callback();
                    }
                  },
                  child: Scrollbar(
                    child: ListView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: <Widget>[
                        widget.testTiles[0].length > 0
                            ? Column(children: widget.testTiles[0])
                            : Empty(title: I18n.of(context).emptyTests),
                        FlatButton(
                          onPressed: () =>
                              setState(() => showPastTests = !showPastTests),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text(I18n.of(context).testPast)),
                              Icon(
                                showPastTests
                                    ? FeatherIcons.chevronUp
                                    : FeatherIcons.chevronDown,
                              ),
                            ],
                          ),
                        ),
                        showPastTests
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: widget.testTiles[1].length > 0
                                    ? Column(children: widget.testTiles[1])
                                    : Empty(
                                        title: I18n.of(context).emptyPastTests),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Offset _getPosition(GlobalKey key) {
//   final RenderBox renderBox = key.currentContext.findRenderObject();
//   final position = renderBox.localToGlobal(Offset.zero);
//   return position;
// }
