import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/dot.dart';
class UpcomingExamTile extends StatelessWidget {
  final String subject;
  final String description;
  final DateTime writeDate;

  UpcomingExamTile(this.subject, this.description, this.writeDate);
  Widget build(BuildContext context) {
    List<String> days = [
      I18n.of(context).dateMonday,
      I18n.of(context).dateTuesday,
      I18n.of(context).dateWednesday,
      I18n.of(context).dateThursday,
      I18n.of(context).dateFriday,
      I18n.of(context).dateSaturday,
      I18n.of(context).dateSunday
    ];
    return Row(children: [
      Padding(child: Dot(size: 5), padding: EdgeInsets.fromLTRB(4, 4, 12, 4)),
      Text((description.length > 20
              ? description.substring(0, 17) + "..."
              : description) +
          " - " +
          capital(subject) +
          " (" +
          days[writeDate.weekday] +
          ")")
    ]);
  }
}
