import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/empty.dart';

class AbsenceTabs extends StatefulWidget {
  final Function callback;
  final _absenceTiles;
  final _delayTiles;
  final _missTiles;
  final _scaffoldKey;

  AbsenceTabs(
    this._scaffoldKey,
    this._absenceTiles,
    this._delayTiles,
    this._missTiles,
    this.callback,
  );

  @override
  _AbsenceTabsState createState() => _AbsenceTabsState();
}

class _AbsenceTabsState extends State<AbsenceTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyAbsences = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyDelays = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyMisses = GlobalKey<RefreshIndicatorState>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: app.tabState.absences.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: app.settings.appColor,
              controller: _tabController,
              onTap: (value) {
                app.tabState.absences.index = value;
                _tabController.animateTo(value);
                app.storage.storage.update("tabs", {"absences": value});
              },
              tabs: <Widget>[
                Tab(
                  child: Text(
                    capital(I18n.of(context).absenceAbsences),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: app.settings.theme.textTheme.bodyText1.color),
                  ),
                ),
                Tab(
                  child: Text(
                    capital(I18n.of(context).absenceDelays),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: app.settings.theme.textTheme.bodyText1.color),
                  ),
                ),
                Tab(
                  child: Text(
                    capital(I18n.of(context).absenceMisses),
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
                physics: BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                children: [
                  // Absences
                  RefreshIndicator(
                    key: _refreshKeyAbsences,
                    onRefresh: () async {
                      if (!await app.user.sync.absence.sync()) {
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
                        children: widget._absenceTiles.length > 0
                            ? widget._absenceTiles
                            : <Widget>[
                                Empty(title: I18n.of(context).emptyAbsences),
                              ],
                      ),
                    ),
                  ),

                  // Delays
                  RefreshIndicator(
                    key: _refreshKeyDelays,
                    onRefresh: () async {
                      if (!await app.user.sync.absence.sync()) {
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
                        children: widget._delayTiles.length > 0
                            ? widget._delayTiles
                            : <Widget>[
                                Empty(title: I18n.of(context).emptyDelays),
                              ],
                      ),
                    ),
                  ),

                  // Misses
                  RefreshIndicator(
                    key: _refreshKeyMisses,
                    onRefresh: () async {
                      if (!await app.user.sync.note.sync()) {
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
                        children: widget._missTiles.length > 0
                            ? widget._missTiles
                            : <Widget>[
                                Empty(title: I18n.of(context).emptyMisses),
                              ],
                      ),
                    ),
                  ), // get from notes
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
