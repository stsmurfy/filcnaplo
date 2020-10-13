import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'builder.dart';
import 'package:filcnaplo/generated/i18n.dart';

class UpcomingExams extends BaseCard {
  UpcomingExamsBuilder builder = UpcomingExamsBuilder();
  @override
  Widget build(BuildContext context) {
    builder.build();
    if (builder.tiles.length == 0) return Container();
    return BaseCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(I18n.of(context).examUpcoming,
                  style: TextStyle(fontSize: 17, color: Colors.black)),
              ListView(shrinkWrap: true, children: builder.tiles)
            ]),
        padding: EdgeInsets.only(left: 30, right: 12, top: 12, bottom: 12));
  }
}
