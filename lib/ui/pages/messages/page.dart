import 'package:flutter/material.dart';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';

//import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:filcnaplo/ui/pages/messages/message/builder.dart';
import 'package:filcnaplo/ui/pages/messages/note/builder.dart';
import 'package:filcnaplo/ui/pages/messages/event/builder.dart';

import 'package:filcnaplo/ui/pages/messages/tabs.dart';
import 'package:filcnaplo/data/context/app.dart';

class MessagesPage extends StatefulWidget {
  final _scaffoldKey;

  MessagesPage(this._scaffoldKey);

  @override
  _MessagesPageState createState() => _MessagesPageState(this._scaffoldKey);
}

class _MessagesPageState extends State<MessagesPage> {
  MessageBuilder _messageBuilder;
  NoteBuilder _noteBuilder;
  EventBuilder _eventBuilder;

  _MessagesPageState(_scaffoldKey) {
    this._messageBuilder = MessageBuilder(_scaffoldKey);
    this._noteBuilder = NoteBuilder();
    this._eventBuilder = EventBuilder();
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
                  I18n.of(context).messageTitle,
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
            child: MessageTabs(
              widget._scaffoldKey,
              _messageBuilder.messageTiles,
              _noteBuilder.noteTiles,
              _eventBuilder.eventTiles,
              callback: updateCallback 
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
    _messageBuilder.build();
    _noteBuilder.build();
    _eventBuilder.build();
  }
}
