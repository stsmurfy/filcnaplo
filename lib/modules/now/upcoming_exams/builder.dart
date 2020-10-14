import 'package:filcnaplo/modules/now/upcoming_exams/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';

class UpcomingExamsBuilder {
  List<UpcomingExamTile> tiles = [];
  void build() {
    List<Exam> exams = app.user.sync.exam.data;
    exams.sort((a, b) => -a.date.compareTo(b.date));
    DateTime now = DateTime.now();

    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    
    DateTime end = lastMidnight.add(Duration(days: 3));
    tiles = exams
        .where((t) =>
            (t.writeDate.isAfter(lastMidnight) &&
                t.writeDate.isBefore(end)) ||
            t.writeDate.isAtSameMomentAs(lastMidnight))
        .map((t) => UpcomingExamTile(t.subjectName, t.description, t.writeDate))
        .toList();
  }
}
