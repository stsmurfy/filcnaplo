import 'package:filcnaplo/data/sync/evaluation.dart';
import 'package:filcnaplo/data/sync/message.dart';
import 'package:filcnaplo/data/sync/note.dart';
import 'package:filcnaplo/data/sync/application.dart';
import 'package:filcnaplo/data/sync/event.dart';
import 'package:filcnaplo/data/sync/student.dart';
import 'package:filcnaplo/data/sync/absence.dart';
import 'package:filcnaplo/data/sync/exam.dart';
import 'package:filcnaplo/data/sync/homework.dart';
import 'package:filcnaplo/data/sync/timetable.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';
import 'dart:async';
class SyncController {
  // Users
  Map<String, SyncUser> users = {};

  // Progress Tracking
  List<Map<String, dynamic>> tasks = [];
  Function updateCallback;
  int currentTask = 0;
  Future<void> fullSyncFinished = Completer().future;
  void addUser(String userID) {
    if (users[userID] == null) users[userID] = SyncUser();
  }

  Future fullSync() async {
    print("INFO: Full sync initiated.");

    tasks = [];

    createTask(
      name: "student",
      task: app.user.sync.student.sync(),
    );

    createTask(
      name: "evaluation",
      task: app.user.sync.evaluation.sync(),
    );

    createTask(
      name: "timetable",
      task: app.user.sync.timetable.sync(),
    );

    createTask(
      name: "homework",
      task: app.user.sync.homework.sync(),
    );

    createTask(
      name: "exam",
      task: app.user.sync.exam.sync(),
    );

    for (var i = 0; i < 3; i++) {
      createTask(
        name: "message",
        task: app.user.sync.messages.sync(i),
      );
    }

    createTask(
      name: "note",
      task: app.user.sync.note.sync(),
    );

    createTask(
      name: "event",
      task: app.user.sync.event.sync(),
    );

    createTask(
      name: "absence",
      task: app.user.sync.absence.sync(),
    );

    if (app.user.isParent) {
      createTask(
        name: "application",
        task: app.user.sync.application.sync(),
      );
    }

    currentTask = 0;
    await Future.forEach(tasks, (task) async {
      try {
        await finishTask(task);
        if (app.debugMode)
          print("DEBUG: Task completed: " +
              task["name"] +
              " (" +
              currentTask.toString() +
              ")");
      } catch (error) {
        print("ERROR: Task " +
            task["name"] +
            " (" +
            currentTask.toString() +
            ")" +
            " failed with: " +
            error.toString());
      }
    });
    tasks = [];
    fullSyncFinished = Future.value(true);
    print("INFO: Full sync completed.");
  }

  createTask({String name, Future task}) {
    tasks.add({"name": name, "task": task});
  }

  Future finishTask(Map task) async {
    if (currentTask >= tasks.length) currentTask = 0;
    currentTask += 1;

    if (updateCallback != null)
      updateCallback(
        task: task["name"],
        current: currentTask,
        max: tasks.length,
      );

    await task["task"];
  }

  void delete() {
    users.forEach((_, sync) {
      sync.messages.delete();
      sync.note.delete();
      sync.application.delete();
      sync.event.delete();
      sync.student.delete();
      sync.evaluation.delete();
      sync.absence.delete();
      sync.exam.delete();
      sync.homework.delete();
      sync.timetable.delete();
    });
  }
}

class SyncUser {
  // Syncers
  MessageSync messages = MessageSync();
  NoteSync note = NoteSync();
  ApplicationSync application = ApplicationSync();
  EventSync event = EventSync();
  StudentSync student = StudentSync();
  EvaluationSync evaluation = EvaluationSync();
  AbsenceSync absence = AbsenceSync();
  ExamSync exam = ExamSync();
  HomeworkSync homework = HomeworkSync();
  TimetableSync timetable = TimetableSync();
  SyncUser() {
    TimetableBuilder builder = TimetableBuilder();
    Week currentWeek = builder.getWeek(builder.getCurrentWeek());
    timetable.from = currentWeek.start;
    timetable.to = currentWeek.end;
  }
}
