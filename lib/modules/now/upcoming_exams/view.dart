import 'package:flutter/material.dart';
import 'builder.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/card.dart';
class UpcomingExams extends BaseCard {
  final UpcomingExamsBuilder builder = UpcomingExamsBuilder();
  @override
  Widget build(BuildContext context) {
    builder.build();
    if (builder.tiles.length == 0) return Container();
    return BaseCard(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Padding(
                  child: Icon(
                    FeatherIcons.calendar,
                    size: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  padding: EdgeInsets.only(right: 10)),
              Text(I18n.of(context).examUpcoming,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold
                  ))
            ]),
            ListView(shrinkWrap: true, children: builder.tiles)
          ]),
    );
  }
}
