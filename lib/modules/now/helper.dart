import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/modules/now/period.dart';
import 'package:filcnaplo/modules/now/mode.dart';

Lesson getCurrentLesson(List<Lesson> lessonsToday, DateTime now) {
  for (Lesson lesson in lessonsToday) {
    bool lessonStarted = lesson.start.isBefore(now);
    bool lessonEnded = lesson.start.add(Duration(minutes: 45)).isBefore(now);
    if (lessonStarted && !lessonEnded) return lesson;
  }
  return null;
}

Period getCurrentPeriod(
    List<Lesson> lessonsToday, DateTime now, int eveningStartHour) {
  if (lessonsToday.length == 0) return Period.Weekend;
  if (lessonsToday[0].start.isAfter(now)) return Period.Morning;
  if (lessonsToday.last.start.add(Duration(minutes: 45)).isBefore(now)) {
    if (now
        .isBefore(DateTime(now.year, now.month, now.day, eveningStartHour))) {
      return Period.Afternoon;
    } else {
      return Period.Evening;
    }
  }

  Lesson currentLesson = getCurrentLesson(lessonsToday, now);
  if (currentLesson != null) return Period.Class;
  return Period.Break;
}

List<Lesson> getLessonsToday(List<Lesson> lessonsThisWeek, DateTime now) {
  return lessonsThisWeek
      .where((e) => (e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day))
      .toList();
}

Mode getMode(List<Lesson> lessonsThisWeek) {
  Set<Period> studyingPeriods = app.settings.studyingPeriods;

  DateTime now = DateTime.now();
  List<Lesson> lessonsToday = getLessonsToday(lessonsThisWeek, now);
  Period currentPeriod = getCurrentPeriod(
      lessonsToday.length == 0 ? [] : lessonsToday,
      now,
      app.settings.eveningStartHour);
  if (currentPeriod == Period.Class) return Mode.AtSchool;
  if (studyingPeriods.contains(currentPeriod)) return Mode.Studying;
  return Mode.Freedom;
}
