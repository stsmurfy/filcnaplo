import 'package:filcnaplo/modules/now/upcoming_todos/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';

class ToDoBuilder {
  List<ToDoTile> examTiles = [];
  List<ToDoTile> homeworkTiles = [];
  void build() {
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    DateTime end = lastMidnight.add(Duration(days: 3));

    List<Exam> exams = app.user.sync.exam.data;
    exams.sort((a, b) => -a.date.compareTo(b.date));
    examTiles = exams
        .where((t) =>
            (t.writeDate.isAfter(lastMidnight) && t.writeDate.isBefore(end)) ||
            t.writeDate.isAtSameMomentAs(lastMidnight))
        .map((t) => ToDoTile(t.subjectName, t.description, t.writeDate))
        .toList();

    List<Homework> homeworks = app.user.sync.homework.data;
    homeworks.sort((a, b) => -a.deadline.compareTo(b.deadline));
    homeworkTiles = homeworks
        .where((h) {
          return (h.deadline.isAfter(lastMidnight) && h.deadline.isBefore(end)) ||
              h.deadline.isAtSameMomentAs(lastMidnight);
        })
        .map((h) => ToDoTile(h.subjectName, h.content, h.deadline))
        .toList();
  }
}
