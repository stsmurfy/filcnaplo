import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/test.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class TestSync {
  List<Test> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Test> tests;
      tests = await app.user.kreta.getTests();

      if (tests == null) {
        await app.user.kreta.refreshLogin();
        tests = await app.user.kreta.getTests();
      }

      if (tests != null) {
        data = tests;

        await app.user.storage.delete("kreta_absences");

        await Future.forEach(tests, (test) async {
          if (test.json != null) {
            await app.user.storage.insert("kreta_absences", {
              "json": jsonEncode(test.json),
            });
          }
        });

        return true;
      } else {
        return false;
      }
    } else {
      //data = Dummy.tests;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
