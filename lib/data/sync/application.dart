import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/application.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class ApplicationSync {
  List<Application> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Application> applications;
      applications = await app.user.kreta.getApplications();

      if (applications == null) {
        await app.user.kreta.refreshLogin();
        applications = await app.user.kreta.getApplications();
      }

      if (applications != null) {
        data = applications;

        try {
          await app.user.storage.delete("kreta_applications");
        }
        catch (_) {
        }

        await Future.forEach(applications, (application) async {
          if (application.json != null) {
            await app.user.storage.insert("kreta_applications", {
              "json": jsonEncode(application.json),
            });
          }
        });
      }

      return applications != null;
    } else {
      data = Dummy.applications;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
