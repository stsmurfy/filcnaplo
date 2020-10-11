import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';

class TomorrowExamsBuilder {
  List<Text> examTexts = [];
  void build() {
    List<Exam> exams = app.user.sync.exam.data;
    exams.sort((a, b) => -a.date.compareTo(b.date));
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    DateTime tomorrowStart = lastMidnight.add(Duration(days: 1));
    DateTime tomorrowEnd = tomorrowStart.add(Duration(days: 1));
    examTexts = exams
        .where((t) =>
            (t.writeDate.isAfter(tomorrowStart) &&
                t.writeDate.isBefore(tomorrowEnd)) ||
            t.writeDate.isAtSameMomentAs(tomorrowStart))
        .map((t) => Text(t.description))
        .toList();
  }
}
