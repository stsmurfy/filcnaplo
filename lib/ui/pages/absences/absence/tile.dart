import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/ui/pages/absences/absence/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class AbsenceTile extends StatelessWidget {
  final Absence absence;

  AbsenceTile(this.absence);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              absence.state == "Igazolt"
                  ? FeatherIcons.check
                  : FeatherIcons.slash,
              color: absence.state == "Igazolt"
                  ? Colors.green
                  : absence.state == "Igazolando"
                      ? Colors.yellow[600]
                      : Colors.red,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  capital(absence.subject.name),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(formatDate(context, absence.date)),
            ),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => AbsenceView(absence)),
    );
  }
}
