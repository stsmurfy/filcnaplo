import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/data/state/sync.dart';
import 'package:filcnaplo/data/sync/ui/indicator.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/absences/page.dart';
import 'package:filcnaplo/ui/pages/messages/compose.dart';
import 'package:filcnaplo/ui/pages/evaluations/dial.dart';
import 'package:filcnaplo/ui/pages/evaluations/page.dart';
import 'package:filcnaplo/ui/pages/home.dart';
import 'package:filcnaplo/ui/pages/messages/page.dart';
import 'package:filcnaplo/ui/pages/planner/page.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/bottom_navbar.dart';

class PageFrame extends StatefulWidget {
  @override
  _PageFrameState createState() => _PageFrameState();
}

class _PageFrameState extends State<PageFrame> {
  GlobalKey<ScaffoldState> _homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Sync at startup
    app.settings.update().then((_) {
      if (app.user.loginState) app.sync.fullSync();
    });
  }

  void _navItemSelected(int item) {
    if (item != app.selectedPage) {
      setState(() {
        app.selectedPage = item;
      });
    }
  }

  SyncState syncState = SyncState();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      app.sync.updateCallback = ({String task, int current, int max}) {
        Map tasks = {
          "message": I18n.of(context).syncMessage,
          "student": I18n.of(context).syncStudent,
          "event": I18n.of(context).syncEvent,
          "note": I18n.of(context).syncNote,
          "evaluation": I18n.of(context).syncEvaluation,
          "recipient": I18n.of(context).syncRecipient,
          "absence": I18n.of(context).syncAbsence,
          "timetable": I18n.of(context).syncTimetable,
          "homework": I18n.of(context).syncHomework,
          "test": I18n.of(context).syncTest,
        };

        setState(() {
          if (task != null)
            syncState =
                SyncState(text: tasks[task] ?? "", current: current, max: max);
        });
      };
    });

    return Scaffold(
      key: _homeKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            // Page content
            () {
              switch (app.selectedPage) {
                case 0:
                  return HomePage();
                case 1:
                  return EvaluationsPage(_homeKey);
                case 2:
                  return PlannerPage(_homeKey);
                case 3:
                  return MessagesPage(_homeKey);
                case 4:
                  return AbsencesPage(_homeKey);
                default:
                  return HomePage();
              }
            }(),

            // Sync Progress Indicator
            (syncState.current != null && app.sync.tasks.length > 0)
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: SyncProgressIndicator(
                      text: syncState.text,
                      current: syncState.current.toString(),
                      max: syncState.max.toString(),
                    ),
                  )
                : Container(),

            // Shadow
            app.settings.theme.brightness == Brightness.light
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 10.0,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey[700],
                          blurRadius: 8.0,
                          offset: Offset(0, 16),
                        )
                      ]),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: (app.selectedPage == 3 && app.tabState.messages.index == 0)
          ? FloatingActionButton(
              child: Icon(FeatherIcons.edit2, color: app.settings.appColor),
              backgroundColor: app.settings.theme.backgroundColor,
              onPressed: () {
                messageContext = MessageContext();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewMessagePage()));
              },
            )
          : (app.selectedPage == 1 && app.tabState.evaluations.index == 0)
              ? EvaluationsDial(
                  (app.evalSortBy / 2).floor(),
                  app.evalSortBy % 2 == 1,
                  onSelect: (int selected) {
                    int newVal = 4 - selected * 2;
                    bool changed = newVal != app.evalSortBy;

                    setState(
                      () => app.evalSortBy = newVal + (changed ? 0 : 1),
                    );
                  },
                )
              : null,
      bottomNavigationBar: BottomNavbar(this._navItemSelected),
    );
  }
}
