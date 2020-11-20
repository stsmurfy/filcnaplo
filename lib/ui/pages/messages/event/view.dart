import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class EventView extends StatelessWidget {
  final Event event;

  EventView(this.event);

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
                  event.title,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              ListTile(
                title: Text(formatDate(context, event.start)),
                trailing: IconButton(
                  icon: Icon(FeatherIcons.share2),
                  onPressed: () {
                    Share.share(event.content);
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
                            data: event.content,
                            onLinkTap: (url) async {
                              if (await canLaunch(url))
                                await launch(url);
                              else
                                throw '[ERROR] MessageView.build: Invalid URL';
                            },
                          )
                        : SelectableLinkify(
                            text: escapeHtml(event.content),
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
