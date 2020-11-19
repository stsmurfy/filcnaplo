import 'package:filcnaplo/data/models/kreta_dictionary_item.dart';
import 'package:filcnaplo/data/models/application.dart';

class Excuse extends Application {
  DateTime start;
  DateTime end;
  KretaDictionaryItem excuseType;

  @override
  String get displayName { return 'Igazolás'; }

  Excuse(
    id,
    sendDate,
    registrationNumber,
    justification,
    studentLastName,
    studentFirstName,
    studentOM,
    fileNumber,
    lastModified,
    type,
    status,
    mailStatus,
    applicant,
    administrator,
    verdicts,
    start,
    end,
    excuseType, {
      json
    }
  ) : super(id, sendDate,registrationNumber, justification, studentLastName, studentFirstName,
      studentOM, fileNumber, lastModified, type, status, mailStatus, applicant,
      administrator, verdicts, json: json);

  factory Excuse.fromJson(Map json) {
    Excuse excuse = new Excuse(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, json: json);

    Application.parseJson(excuse, json);

    excuse.start =json["igazoltTavolletKezdeteDatum"] != null ? DateTime.parse(json["igazoltTavolletKezdeteDatum"]).toLocal() : null;
    excuse.end = json["igazoltTavolletVegeDatum"] != null ? DateTime.parse(json["igazoltTavolletVegeDatum"]).toLocal() : null;
    excuse.excuseType = json["igazolasTipus"] != null ? KretaDictionaryItem.fromJson(json["igazolasTipus"]) : null;

    return excuse;
  }
}