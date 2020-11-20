import 'package:filcnaplo/ui/bottom_card.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:intl/intl.dart';

class AbsenceView extends StatelessWidget {
  final Absence absence;

  AbsenceView(this.absence);

  @override
  Widget build(BuildContext context) {
    // todo: Justify button in parental mode
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ProfileIcon(name: absence.teacher),
            title: Row(
              children: [
                Expanded(
                  child: Text(absence.teacher, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(formatDate(context, absence.date)),
                ),
              ],
            ),
            subtitle: Text(
              capital(absence.subject.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Absence Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              absence.lessonIndex != null
                  ? AbsenceDetail(
                      I18n.of(context).delayLesson,
                      absence.lessonIndex.toString() +
                          ". (" +
                          (absence.lessonStart != null
                              ? DateFormat("HH:mm").format(absence.lessonStart)
                              : I18n.of(context).unknown) +
                          " - " +
                          (absence.lessonEnd != null
                              ? DateFormat("HH:mm").format(absence.lessonEnd)
                              : I18n.of(context).unknown) +
                          ")",
                    )
                  : Container(),
              absence.mode != null
                  ? AbsenceDetail(
                      I18n.of(context).delayMode,
                      absence.mode.description,
                    )
                  : Container(),
              absence.justification != null
                  ? AbsenceDetail(
                      I18n.of(context).absenceJustification,
                      absence.justification.description,
                    )
                  : Container(),
              absence.state != null
                  ? AbsenceDetail(
                      I18n.of(context).delayState,
                      absence.state,
                    )
                  : Container(),
              absence.submitDate != null
                  ? AbsenceDetail(
                      I18n.of(context).administrationTime,
                      formatDate(context, absence.submitDate, showTime: true),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class AbsenceDetail extends StatelessWidget {
  final String title;
  final String value;

  AbsenceDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
