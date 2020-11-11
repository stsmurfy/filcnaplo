import 'package:filcnaplo/data/models/administration_type.dart';
import 'package:filcnaplo/data/models/application.dart';
import 'package:filcnaplo/data/models/document.dart';
import 'package:filcnaplo/kreta/api.dart';

class Verdict {
  Map json;
  int id;
  DateTime date;
  String content;
  KretaUser signatory;
  AdministrationType decision;
  Document filedVerdict;
  AdministrationType mailStatus;

  Verdict(
      this.id,
      this.date,
      this.content,
      this.decision,
      this.signatory,
      this.filedVerdict,
      this.mailStatus,
      {
        this.json,
      });

  factory Verdict.fromJson(Map json) {
    int id = json["azonosito"];
    DateTime date =
    json["hatarozatDatum"] != null ? DateTime.parse(json["hatarozatDatum"]).toLocal() : null;
    String content = json["dontesSzovege"] ?? "";
    KretaUser signatory = KretaUser(null, "", null, json["alairoKretaAzonosito"], "");
    AdministrationType decision = json["dontes"] != null ? AdministrationType.fromJson(json["dontes"]) : null;
    Document filedVerdict = json["iktatottHatarozat"] != null ? Document.fromJson(AdminEndpoints.downloadVerdict, json["iktatottHatarozat"]) : null;
    AdministrationType mailStatus = json["postazasiStatusz"] != null ? AdministrationType.fromJson(json["postazasiStatusz"]) : null;

    return Verdict(
      id,
      date,
      content,
      decision,
      signatory,
      filedVerdict,
      mailStatus,
      json: json,
    );
  }
}
