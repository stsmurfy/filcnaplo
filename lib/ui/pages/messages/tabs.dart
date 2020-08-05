import 'package:filcnaplo/ui/empty.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
//import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class MessageTabs extends StatefulWidget {
  final _scaffoldKey;
  final messageTiles;
  final noteTiles;
  final eventTiles;
  final Function callback;

  MessageTabs(
    this._scaffoldKey,
    this.messageTiles,
    this.noteTiles,
    this.eventTiles, {
    this.callback,
  });

  @override
  _MessageTabsState createState() => _MessageTabsState();
}

class _MessageTabsState extends State<MessageTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyMessages = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyNotes = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyEvents = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: app.tabState.messages.index,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _menuKeyMessages = GlobalKey();

    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            labelPadding: EdgeInsets.zero,
            indicatorColor: app.settings.appColor,
            controller: _tabController,
            onTap: (value) {
              app.tabState.messages.index = value;
              _tabController.animateTo(value);
              app.sync.updateCallback();
              app.storage.storage.update("tabs", {"messages": value});
            },
            tabs: [
              SizedBox(
                height: 46.0,
                child: FlatButton(
                  key: _menuKeyMessages,
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
                                  capital(I18n.of(context).messageDrawerInbox),
                                  capital(I18n.of(context).messageDrawerSent),
                                  capital(I18n.of(context).messageDrawerTrash),
                                  capital(I18n.of(context).messageDrawerDrafts),
                                ][app.selectedMessagePage],
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
                          Offset pos = _getPosition(_menuKeyMessages);
                          return RelativeRect.fromLTRB(0, pos.dy, pos.dx, 0);
                        }(),
                        items: [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                                capital(I18n.of(context).messageDrawerInbox)),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(
                                capital(I18n.of(context).messageDrawerSent)),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text(
                                capital(I18n.of(context).messageDrawerTrash)),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Text(
                                capital(I18n.of(context).messageDrawerDrafts)),
                          ),
                        ],
                      ).then((value) {
                        if (value != null)
                          setState(() => app.selectedMessagePage = value - 1);
                      });
                    } else {
                      app.tabState.messages.index = 0;
                      _tabController.animateTo(0);
                      app.sync.updateCallback();
                      app.storage.storage.update("tabs", {"messages": 0});
                    }
                  },
                ),
              ),
              Tab(
                child: Text(
                  capital(I18n.of(context).drawerNotes),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: app.settings.theme.textTheme.bodyText1.color),
                ),
              ),
              Tab(
                child: Text(
                  capital(I18n.of(context).eventTitle),
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
                // Messages
                RefreshIndicator(
                  key: _refreshKeyMessages,
                  onRefresh: () async {
                    if (!await app.user.sync.messages
                        .sync(app.selectedMessagePage)) {
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

                  // Message Tiles
                  child: Scrollbar(
                    child: ListView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.only(top: 12.0),
                      children: [
                        Column(
                          children: widget.messageTiles[app.selectedMessagePage]
                                      .length >
                                  0
                              ? widget.messageTiles[app.selectedMessagePage]
                              : <Widget>[
                                  Empty(
                                    title: app.selectedMessagePage == 3
                                        ? I18n.of(context).notImplemented
                                        : I18n.of(context).emptyMessages,
                                  ),
                                ],
                        ),
                        SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),

                // Notes
                RefreshIndicator(
                  key: _refreshKeyNotes,
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
                      children: widget.noteTiles.length > 0
                          ? widget.noteTiles
                          : <Widget>[
                              Empty(title: I18n.of(context).emptyNotes),
                            ],
                    ),
                  ),
                ),

                // Events
                RefreshIndicator(
                  key: _refreshKeyEvents,
                  onRefresh: () async {
                    if (!await app.user.sync.event.sync()) {
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
                      children: widget.eventTiles.length > 0
                          ? widget.eventTiles
                          : <Widget>[
                              Empty(title: I18n.of(context).emptyEvents),
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

Offset _getPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final position = renderBox.localToGlobal(Offset.zero);
  return position;
}
