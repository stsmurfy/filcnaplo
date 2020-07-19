import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/test.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/ui/pages/planner/tests/view.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class TimetableView extends StatelessWidget {
  final Lesson lesson;
  final Homework homework;
  final List<Test> tests;

  TimetableView(this.lesson, this.homework, this.tests);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: ProfileIcon(
                name: lesson.substituteTeacher != ""
                    ? lesson.substituteTeacher
                    : lesson.teacher),
            title: Row(children: [
              Expanded(
                child: Text(capitalize(lesson.substituteTeacher != ""
                    ? lesson.substituteTeacher
                    : lesson.teacher)),
              ),
              Text(formatDate(context, lesson.date)),
            ]),
            subtitle: Text(
              lesson.subject != null ? capital(lesson.subject.name) : "?",
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Lesson Details
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                lesson.description != ""
                    ? TimetableDetail(
                        I18n.of(context).evaluationDescription,
                        lesson.description,
                      )
                    : Container(),
                lesson.lessonYearIndex != null
                    ? TimetableDetail(
                        I18n.of(context).timetableYearly,
                        lesson.lessonYearIndex.toString() + ".",
                      )
                    : Container(),
                lesson.status.name != "Naplozott"
                    ? TimetableDetail(
                        I18n.of(context).state,
                        lesson.status.description,
                      )
                    : Container(),
                lesson.substituteTeacher != ""
                    ? TimetableDetail(
                        I18n.of(context).substituteTeacher,
                        lesson.substituteTeacher,
                      )
                    : Container(),
                homework != null ? homeworkButton(context) : Container(),
                tests.length > 0
                    ? Column(
                        children: tests
                            .map((test) => testButton(context, test))
                            .toList(),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget homeworkButton(BuildContext context) {
    return FlatButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeworkView(homework, onSolved),
      ),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FeatherIcons.home),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              capital(I18n.of(context).homework),
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget testButton(BuildContext context, Test test) {
    return FlatButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => TestView(test),
      ),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FeatherIcons.edit),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              I18n.of(context).test,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  void onSolved(homework) {
    app.user.sync.homework.data
        .firstWhere((h) => h.id == homework.id)
        .isSolved = !homework.isSolved;

    app.user.kreta.homeworkSolved(homework, homework.isSolved);
  }
}

class TimetableDetail extends StatelessWidget {
  final String title;
  final String value;

  TimetableDetail(this.title, this.value);

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
