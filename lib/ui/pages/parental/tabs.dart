import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';

class ParentalTabs extends StatefulWidget {
  final _scaffoldKey;
  final applicationTiles;
  final Function callback;

  ParentalTabs(
    this._scaffoldKey,
    this.applicationTiles, {
    this.callback,
  });

  @override
  _ParentalTabsState createState() => _ParentalTabsState();
}

class _ParentalTabsState extends State<ParentalTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyApplications = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    );
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
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              forceElevated: true,
              leading: Icon(FeatherIcons.atSign),
              title: Text("e-Ügyintézés"),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: app.user.profileIcon,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage()));
                    },
                  ),
                ),
              ],
              /*bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  app.tabState.timetable.index = value;
                  _tabController.animateTo(value);
                  app.sync.updateCallback();
                },
                labels: [
                  CustomLabel(title: "Kérelmek"),
                ],
              ),*/
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            // Applications
            RefreshIndicator(
              key: _refreshKeyApplications,
              onRefresh: () async {
                if (!await app.user.sync.application.sync()) {
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
              child: CupertinoScrollbar(
                child: ListView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(top: 12.0),
                    children: [
                      Column(
                        children: widget.applicationTiles.length > 0
                            ? widget.applicationTiles
                            : <Widget>[
                                Empty(
                                  title: I18n.of(context).emptyMessages,
                                ),
                              ],
                      ),
                      SizedBox(height: 100.0),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
