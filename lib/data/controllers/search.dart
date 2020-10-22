import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/searchable.dart';
import 'package:filcnaplo/data/models/school.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/cards/absence/tile.dart';
import 'package:filcnaplo/ui/pages/absences/absence/view.dart';
import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:filcnaplo/ui/cards/evaluation/view.dart';
import 'package:filcnaplo/ui/cards/homework/tile.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/ui/cards/exam/tile.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';
import 'package:filcnaplo/ui/cards/message/tile.dart';
import 'package:filcnaplo/ui/pages/messages/message/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class SearchController {
  static String specialChars(String s) => s
      .replaceAll("é", "e")
      .replaceAll("á", "a")
      .replaceAll("ó", "o")
      .replaceAll("ő", "o")
      .replaceAll("ö", "o")
      .replaceAll("ú", "u")
      .replaceAll("ű", "u")
      .replaceAll("ü", "u")
      .replaceAll("í", "i");

  static List<School> schoolResults(List<School> all, String pattern) {
    pattern = specialChars(pattern.toLowerCase());
    if (pattern == "") return all;

    List<School> results = [];

    all.forEach((item) {
      int contains = 0;

      pattern.split(" ").forEach((variation) {
        if (specialChars(item.name.toLowerCase()).contains(variation)) {
          contains++;
        }
      });

      if (contains == pattern.split(" ").length) results.add(item);
    });

    results.sort((a, b) => a.name.compareTo(b.name));

    return results;
  }

  static List<Recipient> recipientResults(List<Recipient> all, String pattern) {
    pattern = specialChars(pattern.toLowerCase());
    if (pattern == "") return all;

    List<Recipient> results = [];

    all.forEach((item) {
      int contains = 0;

      pattern.split(" ").forEach((variation) {
        if (specialChars(item.name.toLowerCase()).contains(variation)) {
          contains++;
        }
      });

      if (contains == pattern.split(" ").length) results.add(item);
    });

    results.sort((a, b) => a.name.compareTo(b.name));

    return results;
  }

  static List<Searchable> searchableResults(List all, String pattern) {
    pattern = specialChars(pattern.toLowerCase());
    if (pattern == "") return [];

    List<Searchable> results = all
        .where((item) => pattern.split(" ").every((variation) =>
            specialChars(item.text.toLowerCase()).contains(variation)))
        .toList();

    results.sort((a, b) => a.text.compareTo(b.text));

    return results;
  }

  List<Searchable> getSearchables(BuildContext context) {
    List<Searchable> searchables = [];

    List<Message> messages = <List<Message>>[
      app.user.sync.messages.data[0],
      app.user.sync.messages.data[1],
      app.user.sync.messages.data[2],
    ].expand((x) => x).toList();

    messages.forEach((message) => searchables.add(Searchable(
        text: searchString([escapeHtml(message.content), message.subject]),
        child: GestureDetector(
          child: MessageTile(message),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MessageView([message])));
          },
        ),
    )));

    // Absences
    app.user.sync.absence.data.forEach((absence) => searchables.add(Searchable(
      text: searchString([absence.teacher, absence.subject.name, absence.type.description, absence.mode.description]),
      child: GestureDetector(
        child: AbsenceTile(absence),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => AbsenceView(absence),
          );
        },
      ),
    )));

    // Homeworks
    app.user.sync.homework.data.forEach((homework) => searchables.add(Searchable(
      text: searchString([homework.teacher, homework.subjectName, homework.content]),
      child: GestureDetector(
        child: HomeworkTile(homework),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => HomeworkView(homework, () => {}),
          );
        },
      ),
    )));

    // Exams
    app.user.sync.exam.data.forEach((exam) => searchables.add(Searchable(
      text: searchString([exam.teacher, exam.subjectName, exam.description]),
      child: GestureDetector(
        child: ExamTile(exam),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => ExamView(exam),
          );
        },
      ),
    )));

    // Evaluations
    app.user.sync.evaluation.data[0]
        .forEach((evaluation) => searchables.add(Searchable(
                text: searchString([evaluation.description, evaluation.subject.name,
				evaluation.value.weight != 0
				 ? "${evaluation.value.weight}%"
				 : "100%"]),
                child: GestureDetector(
                  child: EvaluationTile(evaluation),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EvaluationView(evaluation),
                    );
                  },
                ),
            )));

    return searchables;
  }

  String searchString(List<String> keys) => keys.join(" ");
}
