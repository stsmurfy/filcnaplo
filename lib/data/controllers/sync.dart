import 'package:filcnaplo/data/sync/evaluation.dart';
import 'package:filcnaplo/data/sync/message.dart';
import 'package:filcnaplo/data/sync/recipient.dart';
import 'package:filcnaplo/data/sync/note.dart';
import 'package:filcnaplo/data/sync/event.dart';
import 'package:filcnaplo/data/sync/student.dart';
import 'package:filcnaplo/data/sync/absence.dart';
import 'package:filcnaplo/data/sync/test.dart';
import 'package:filcnaplo/data/sync/homework.dart';
import 'package:filcnaplo/data/sync/timetable.dart';
import 'package:filcnaplo/data/context/app.dart';

class SyncController {
  // Users
  Map<String, SyncUser> users = {};

  // Progress Tracking
  List<Map<String, dynamic>> tasks = [];
  Function updateCallback;
  int currentTask = 0;

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
      name: "test",
      task: app.user.sync.test.sync(),
    );

    createTask(
      name: "recipient",
      task: app.user.sync.recipients.sync(),
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

    currentTask = 0;
    await Future.forEach(tasks, (task) async {
      try {
        await finishTask(task);
        if (app.debugVersion)
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
      sync.recipients.delete();
      sync.note.delete();
      sync.event.delete();
      sync.student.delete();
      sync.evaluation.delete();
      sync.absence.delete();
      sync.test.delete();
      sync.homework.delete();
      sync.timetable.delete();
    });
  }
}

class SyncUser {
  // Syncers
  MessageSync messages = MessageSync();
  RecipientSync recipients = RecipientSync();
  NoteSync note = NoteSync();
  EventSync event = EventSync();
  StudentSync student = StudentSync();
  EvaluationSync evaluation = EvaluationSync();
  AbsenceSync absence = AbsenceSync();
  TestSync test = TestSync();
  HomeworkSync homework = HomeworkSync();
  TimetableSync timetable = TimetableSync();
}
