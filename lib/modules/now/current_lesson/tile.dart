import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class CurrentLessonTile extends StatelessWidget {
  final String subject;
  final String description;
  final String room;
  final int timeLeft;
  CurrentLessonTile(this.subject, this.description, this.room, this.timeLeft);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(children: [
          Padding(
            child: Column(children: [
              Row(children: [
                Text(subject, style: TextStyle(fontSize: 16)),
                Text(room)
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Row(children: [
                Text(description, style: TextStyle(color: Colors.grey[300])),
                Text(timeLeft.toString() + " " + I18n.of(context).timeMinute)
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
            ]),
            padding: EdgeInsets.all(20),
          ),
          LinearProgressIndicator(
              value: (45 - timeLeft) / 45,
              minHeight: 8,
              backgroundColor: Color(0x25FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)
          )
        ]));
  }
}
