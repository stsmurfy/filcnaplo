import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/test.dart';
import 'package:filcnaplo/ui/pages/planner/tests/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class TestTile extends StatelessWidget {
  final Test test;
  final bool isPast;

  TestTile(this.test, this.isPast);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              isPast ? FeatherIcons.checkSquare : FeatherIcons.edit,
              color: isPast ? Colors.green : app.settings.appColor,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  capital(test.subjectName) +
                      " (" +
                      test.subjectIndex.toString() +
                      ".)",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(formatDate(context, test.date)),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => TestView(test),
      ),
    );
  }
}
