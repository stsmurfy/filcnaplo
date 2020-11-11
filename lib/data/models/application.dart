import 'package:filcnaplo/data/models/administration_type.dart';
import 'package:filcnaplo/data/models/document.dart';
import 'package:filcnaplo/data/models/verdict.dart';
import 'package:filcnaplo/kreta/api.dart';

class Application {
  Map json;
  int id;
  DateTime sendDate;
  String registrationNumber;
  String justification;
  String studentLastName;
  String studentFirstName;
  String studentOM;
  String fileNumber;
  DateTime lastModified;
  AdministrationType type;
  AdministrationType status;
  AdministrationType mailStatus;
  KretaUser applicant;
  KretaUser administrator;
  Document filedApplication;
  List<Verdict> verdicts;

  String get displayName { return 'Kérelem'; }

  Application(
    this.id,
    this.sendDate,
    this.registrationNumber,
    this.justification,
    this.studentLastName,
    this.studentFirstName,
    this.studentOM,
    this.fileNumber,
    this.lastModified,
    this.type,
    this.status,
    this.mailStatus,
    this.applicant,
    this.administrator,
    this.verdicts, {
    this.json,
  });

  static void parseJson(Application instance, Map json) {
    instance.id = json["azonosito"];
    instance.sendDate = json["bekuldesDatum"] != null
        ? DateTime.parse(json["bekuldesDatum"]).toLocal()
        : null;
    instance.registrationNumber = json["iktatoszam"] ?? "";
    instance.justification = json["indoklas"] ?? "";
    instance.studentLastName = json["tanuloCsaladiNev"] ?? "";
    instance.studentFirstName = json["tanuloKeresztNev"] ?? "";
    instance.studentOM = json["tanuloOktatasiAzonosito"] ?? "";
    instance.fileNumber = json["ugyiratszam"] ?? "";
    instance.lastModified = json["utolsoModositasDatum"] != null
        ? DateTime.parse(json["utolsoModositasDatum"]).toLocal()
        : null;
    instance.type = json["tipus"] != null
        ? AdministrationType.fromJson(json["tipus"])
        : null;
    instance.status = json["statusz"] != null
        ? AdministrationType.fromJson(json["statusz"])
        : null;
    instance.mailStatus = json["postazasiStatusz"] != null
        ? AdministrationType.fromJson(json["postazasiStatusz"])
        : null;
    instance.applicant = json["kerelmezo"] != null
        ? KretaUser.fromJson(json["kerelmezo"])
        : null;
    instance.administrator = json["ugyintezo"] != null
        ? KretaUser.fromJson(json["ugyintezo"])
        : null;
    instance.filedApplication = json["iktatottKerelem"] != null
        ? Document.fromJson(
            AdminEndpoints.downloadApplication, json["iktatottKerelem"])
        : null;

    instance.verdicts = [];

    if (json["hatarozatLista"] != null) {
      json["hatarozatLista"].forEach((verdict) {
        instance.verdicts.add(Verdict.fromJson(verdict));
      });
    }
  }

  factory Application.fromJson(Map json) {
    Application app = new Application(null, null, null, null, null, null, null,
        null, null, null, null, null, null, null, null,
        json: json);

    parseJson(app, json);

    return app;
  }
}

class KretaUser {
  int id;
  String name;
  int kretaId;
  String uid;
  String title;

  KretaUser(this.id, this.name, this.title, this.kretaId, this.uid);

  factory KretaUser.fromJson(Map json) {
    int id = json["azonosito"];
    String name = json["nev"] ?? "";
    String title = json["titulus"] != null
        ? (json["titulus"] == "nincs" ? "" : json["titulus"])
        : "";
    int kretaId = json["kretaAzonosito"] ?? json["kretaFelhasznaloAzonosito"];
    String uid = json["egyediAzonosito"] ?? "";

    return KretaUser(id, name, title, kretaId, uid);
  }
}
