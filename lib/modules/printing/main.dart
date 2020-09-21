import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';

/*
Author: daaniiieel
Name: Timetable Printer (Experimental)
Description: This module prints out the timetable for the selected user on the 
current week.
*/

class TimetablePrinter {
  String dayNames(BuildContext context, int i) => [
        I18n.of(context).dateMondayShort,
        I18n.of(context).dateTuesdayShort,
        I18n.of(context).dateWednesdayShort,
        I18n.of(context).dateThursdayShort,
        I18n.of(context).dateFridayShort,
        I18n.of(context).dateSaturdayShort,
        I18n.of(context).dateSundayShort,
      ][i - 1];

  pw.Document build(
      BuildContext context, pw.Document pdf, List<Day> days, int min, int max) {
    List rows = <pw.TableRow>[];

    // build header row
    List<pw.Widget> headerChildren = <pw.Widget>[pw.Text('')];
    days.forEach((day) {
      headerChildren.add(pw.Padding(
          padding: pw.EdgeInsets.all(5),
          child:
              pw.Center(child: pw.Text(dayNames(context, day.date.weekday)))));
    });
    pw.TableRow headerRow = pw.TableRow(
        children: headerChildren,
        verticalAlignment: pw.TableCellVerticalAlignment.middle);
    rows.add(headerRow);

    // build timetable
    for (int i = min; i <= max; i++) {
      List<pw.Widget> thisChildren = <pw.Widget>[];

      // lesson index at the start of the row
      thisChildren.add(pw.Padding(
        padding: pw.EdgeInsets.all(5),
        child: pw.Center(child: pw.Text('$i. ')),
      ));

      days.forEach((Day day) {
        var isNotEmpty = day.lessons.any((element) =>
            element.lessonIndex != '+' && int.parse(element.lessonIndex) == i);

        for (Lesson lesson in day.lessons) {
          if (lesson.lessonIndex == '+') {
            continue;
          }
          if (isNotEmpty) {
            if (int.parse(lesson.lessonIndex) == i) {
              String name = lesson.subject.name ?? lesson.name;
              String room = lesson.room ?? '';

              thisChildren.add(pw.Padding(
                  padding: pw.EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: pw.Column(children: <pw.Widget>[
                    pw.Align(
                        child: pw.Text(name), alignment: pw.Alignment.center),
                    pw.Footer(
                        leading: pw.Text(room),
                        trailing: pw.Text(monogram(lesson.teacher))),
                  ])));
            }
          } else {
            thisChildren.add(pw.Container());
            break;
          }
        }
      });
      pw.TableRow thisRow = pw.TableRow(
        children: thisChildren,
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
      );
      rows.add(thisRow);
    }

    // add timetable to pdf
    pw.Table table = pw.Table(
      children: rows,
      border: pw.TableBorder(bottom: true, top: true, left: true, right: true),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    );

    // header and footer
    pw.Footer footer = pw.Footer(
      trailing: pw.Text('filcnaplo.hu'),
      margin: pw.EdgeInsets.only(top: 12.0),
    );
    String className = app.user.sync.student.data.className;

    pw.Footer header = pw.Footer(
      margin: pw.EdgeInsets.all(5),
      title: pw.Text(className, style: pw.TextStyle(fontSize: 30)),
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4
            .landscape, // so the page looks normal both in portrait and landscape
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) =>
            pw.Column(children: <pw.Widget>[header, table, footer])));

    return pdf;
  }

  void printPDF(final _scaffoldKey, BuildContext context) {
    // pdf theme (for unicode support)
    rootBundle.load("assets/Roboto-Regular.ttf").then((font) {
      pw.ThemeData myTheme = pw.ThemeData.withFont(base: pw.Font.ttf(font));
      pw.Document pdf = pw.Document(theme: myTheme);

      // sync indicator
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          I18n.of(context).syncTimetable,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
      ));

      // get a builder and build current week
      final timetableBuilder = TimetableBuilder();
      timetableBuilder.build(timetableBuilder.getCurrentWeek());

      int minLessonIndex = 1;
      int maxLessonIndex = 1;
      List<Day> weekDays = timetableBuilder.week.days;
      for (Day day in weekDays) {
        for (Lesson lesson in day.lessons) {
          if (lesson.lessonIndex == '+') {
            continue;
          }
          if (int.parse(lesson.lessonIndex) < minLessonIndex) {
            minLessonIndex = int.parse(lesson.lessonIndex);
          }
          if (int.parse(lesson.lessonIndex) > maxLessonIndex) {
            maxLessonIndex = int.parse(lesson.lessonIndex);
          }
        }
      }

      pdf = build(context, pdf, weekDays, minLessonIndex, maxLessonIndex);

      // print pdf
      Printing.layoutPdf(onLayout: (format) => pdf.save()).then((success) {
        if (success)
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              I18n.of(context).settingsExportExportTimetableSuccess,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[700],
          ));
      });
    });
  }
}
