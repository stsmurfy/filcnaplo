import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:intl/intl.dart';

class BackgroundController {
  static init() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          startOnBoot: true,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY),
      _notificationsTask,
    ).then((int status) {
      print("INFO: [BackgroundFetch] configure status: " + status.toString());
    }).catchError((error) {
      print("ERROR: [BackgroundFetch] configure failed: " + error.toString());
    });

    BackgroundFetch.registerHeadlessTask(_notificationsTask);

    app.sync.listener.listen((user) {
      check(DateTime.now().add(Duration(days: -10)));
    });
  }

  static check(DateTime lastSync) {
    int i = 0;
    String userName = ''; //'' [' + app.user.name + ']';

    // Evaluations
    (app.user.sync.evaluation.data[0] as List<Evaluation>)
        .forEach((evaluation) {
      if (evaluation.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'evaluations',
              title: 'Új jegy' + userName,
              body:
              "${evaluation.subject.name}: ${evaluation.value.value} (${evaluation.value.weight}%)",
            ));
      }
    });

    // Homeworks
    (app.user.sync.homework.data as List<Homework>).forEach((homework) {
      if (homework.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'homeworks',
              title: 'Új házi feladat' + userName,
              body: "${homework.subjectName}, Határidő: " +
                  DateFormat('yyyy. MM. dd.').format(homework.deadline),
            ));
      }
    });

    // Messages
    (app.user.sync.messages.data[0] as List<Message>).forEach((message) {
      if (message.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'messages',
              title: 'Új üzenet' + userName,
              body: "${message.subject}",
            ));
      }
    });

    // Exams
    (app.user.sync.exam.data as List<Exam>).forEach((exam) {
      if (exam.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'exams',
              title: 'Új dolgozat' + userName,
              body: "${exam.subjectName}: ${exam.mode.name}",
            ));
      }
    });

    // Notes
    (app.user.sync.note.data as List<Note>).forEach((note) {
      if (note.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'notes',
              title: 'Új feljegyzés' + userName,
              body: "${note.title}",
            ));
      }
    });

    // Absences
    (app.user.sync.absence.data as List<Absence>).forEach((absence) {
      if (absence.date.isAfter(lastSync)) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: i++,
              channelKey: 'absences',
              title: 'Mulasztás' + userName,
              body: "(${absence.lessonIndex}. óra) ${absence.subject.name}, " +
                  DateFormat('yyyy. MM. dd.').format(absence.date),
            ));
      }
    });
  }

  static _notificationsTask(String taskId) async {
    print('[BackgroundFetch] Task received: $taskId');

    DateTime lastSync = app.user.sync.lastSync; //DateTime.now().add(Duration(days: -10));

    await app.sync.fullSync();

    //check(lastSync);

    BackgroundFetch.finish(taskId);
  }
}
