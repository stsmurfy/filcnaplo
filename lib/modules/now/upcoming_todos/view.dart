import 'package:filcnaplo/modules/now/upcoming_todos/tile.dart';
import 'package:flutter/material.dart';
import 'builder.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/card.dart';

class ToDoList extends StatelessWidget {
  String title;
  List<ToDoTile> tiles;
  IconData icon;
  ToDoList(this.icon, this.title, this.tiles);
  @override
  Widget build(BuildContext context) {
    return Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
              Padding(
                  child: Icon(
                    icon,
                    size: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  padding: EdgeInsets.only(right: 10)),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold))
            ]),
            ListView(
              shrinkWrap: true,
              children: tiles,
              padding: EdgeInsets.all(3),
            )
          ],
        ),
        padding: EdgeInsets.only(top: 8, left: 8));
  }
}

class UpcomingToDoList extends BaseCard {
  final ToDoBuilder builder = ToDoBuilder();
  @override
  Widget build(BuildContext context) {
    builder.build();
    bool noExams = builder.examTiles.length == 0,
        noHomeworks = builder.homeworkTiles.length == 0;
    if (noExams && noHomeworks) return Container();
    return BaseCard(
        child: Column(children: [
      !noExams
          ? ToDoList(FeatherIcons.calendar, I18n.of(context).examUpcoming, builder.examTiles)
          : Container(),
      !noHomeworks
          ? ToDoList(FeatherIcons.home, I18n.of(context).homeworkUpcoming, builder.homeworkTiles)
          : Container()
    ]));
  }
}

class UpcomingExams extends BaseCard {
  final ToDoBuilder builder = ToDoBuilder();
  @override
  Widget build(BuildContext context) {
    builder.build();
    if (builder.examTiles.length == 0 && builder.homeworkTiles.length == 0)
      return Container();
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
                      fontWeight: FontWeight.bold))
            ]),
            ListView(shrinkWrap: true, children: builder.examTiles)
          ]),
    );
  }
}
