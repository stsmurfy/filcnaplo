import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46.0,
        height: 46.0,
        alignment: Alignment.center,
        child: ProfileIcon(name: message.sender)
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message.sender,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(formatDate(context, message.date)),
          ),
        ],
      ),
      subtitle: Text(
        message.subject + "\n" + escapeHtml(message.content),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
