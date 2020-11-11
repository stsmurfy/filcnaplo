import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/application.dart';
import 'package:filcnaplo/data/models/excuse.dart';
import 'package:filcnaplo/ui/pages/parental/application/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class ApplicationTile extends StatelessWidget {
  final Application application;

  ApplicationTile(this.application);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FeatherIcons.inbox,
                  color: Theme.of(context).accentColor)),
          title: Row(children: <Widget>[
            Expanded(
              child: Text(
                application.type.code + " - " + application.displayName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Text(formatDate(context, application.lastModified),
                textAlign: TextAlign.right),
          ]),
          subtitle:
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(
              application.status.name,
              overflow: TextOverflow.ellipsis,
            )),
            Text(formatDate(context, application.sendDate),
                textAlign: TextAlign.right),
          ]),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApplicationView(application)));
      },
    );
  }
}
