import 'package:filcnaplo/data/sync/evaluation.dart';
import 'package:filcnaplo/data/sync/message.dart';
import 'package:filcnaplo/data/sync/note.dart';
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
  StreamController<SyncUser> _controller = StreamController<SyncUser>();

  get listener {
    return _controller.stream;
  }

  void addUser(String userID) {
    if (users[userID] == null) users[userID] = SyncUser();
  }

  Future fullSync({ SyncUser sync }) async {
    if (sync == null)
      sync = app.user.sync;

    print("INFO: Full sync initiated.");

    tasks = [];

    createTask(
      name: "student",
      task: sync.student.sync(),
    );

    createTask(
      name: "evaluation",
      task: sync.evaluation.sync(),
    );

    createTask(
      name: "timetable",
      task: sync.timetable.sync(),
    );

    createTask(
      name: "homework",
      task: sync.homework.sync(),
    );

    createTask(
      name: "exam",
      task: sync.exam.sync(),
    );

    for (var i = 0; i < 3; i++) {
      createTask(
        name: "message",
        task: sync.messages.sync(i),
      );
    }

    createTask(
      name: "note",
      task: sync.note.sync(),
    );

    createTask(
      name: "event",
      task: sync.event.sync(),
    );

    createTask(
      name: "absence",
      task: sync.absence.sync(),
    );

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
    sync.lastSync = DateTime.now();
    _controller.add(sync);
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
  EventSync event = EventSync();
  StudentSync student = StudentSync();
  EvaluationSync evaluation = EvaluationSync();
  AbsenceSync absence = AbsenceSync();
  ExamSync exam = ExamSync();
  HomeworkSync homework = HomeworkSync();
  TimetableSync timetable = TimetableSync();
  DateTime lastSync = DateTime.utc(0);

  SyncUser() {
    TimetableBuilder builder = TimetableBuilder();
    Week currentWeek = builder.getWeek(builder.getCurrentWeek());
    timetable.from = currentWeek.start;
    timetable.to = currentWeek.end;
  }
}
