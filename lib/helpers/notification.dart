import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static init() {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelKey: 'evaluations',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
          NotificationChannel(
              channelKey: 'homeworks',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
          NotificationChannel(
              channelKey: 'messages',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
          NotificationChannel(
              channelKey: 'exams',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
          NotificationChannel(
              channelKey: 'notes',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
          NotificationChannel(
              channelKey: 'absences',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF236A5B),
              ledColor: Colors.white
          ),
        ]
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      print(receivedNotification);
          /*Navigator.of(context).pushName(context,
              '/NotificationPage',
              arguments: { id: receivedNotification.id } // your page params. I recommend to you to pass all *receivedNotification* object
          );
*/
        }
    );
  }
}