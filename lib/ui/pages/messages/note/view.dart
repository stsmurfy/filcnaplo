import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/context/app.dart';

class NoteView extends StatelessWidget {
  final Note note;

  NoteView(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        color: app.settings.theme.backgroundColor,
      ),
      margin: EdgeInsets.only(top: 64.0),
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              ListTile(
                leading: ProfileIcon(name: note.teacher),
                title: Text(note.teacher),
                subtitle: Text(formatDate(context, note.date)),
                trailing: IconButton(
                  icon: Icon(FeatherIcons.share2),
                  onPressed: () {
                    Share.share(note.content);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: CupertinoScrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
                    child: app.settings.renderHtml
                      ? Html(
                          data: note.content,
                          onLinkTap: (url) async {
                            if (await canLaunch(url))
                              await launch(url);
                            else
                              throw '[ERROR] MessageView.build: Invalid URL';
                          },
                        )
                      : SelectableLinkify(
                          text: escapeHtml(note.content),
                          onOpen: (url) async {
                            if (await canLaunch(url.url))
                              await launch(url.url);
                            else
                              throw '[ERROR] MessageView.build: nvalid URL';
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
