import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:flutter/material.dart';

class AbsenceTile extends StatelessWidget {
  final Absence absence;

  AbsenceTile(this.absence);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            width: 46.0,
            height: 46.0,
            alignment: Alignment.center,
            child: Icon(
                absence.state == "Igazolando"
                    ? FeatherIcons.slash
                    : FeatherIcons.check,
                color: absence.state == "Igazolando"
                    ? Colors.yellow[600]
                    : Colors.green)),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                absence.type.description,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(formatDate(context, absence.submitDate)),
            ),
          ],
        ),
        subtitle: Text(
          absence.mode.description + '\n' + absence.subject.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
