import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'builder.dart';

class TomorrowExams extends BaseCard {
  @override
  Widget build(BuildContext context) {
    TomorrowExamsBuilder builder = TomorrowExamsBuilder();
    builder.build();
    if (builder.examTexts.length == 0) return Container();
    return BaseCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Text("Holnapi dolgozatok"),
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20),
              children: builder.examTexts)
        ]));
  }
}