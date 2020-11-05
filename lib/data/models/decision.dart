import 'package:filcnaplo/data/models/type.dart';

class Decision {
  Map json;
  String id;
  String title;
  DateTime date;
  DateTime start;
  DateTime end;
  String signatoryId;
  bool send;
  String content;
  Type type;

  Decision(
      this.id,
      this.title,
      this.date,
      this.createDate,
      this.teacher,
      this.seenDate,
      this.groupId,
      this.content,
      this.type, {
        this.json,
      });

  factory Decision.fromJson(Map json) {
    String id = json["Uid"];
    String title = json["Cim"] ?? "";
    DateTime date =
    json["Datum"] != null ? DateTime.parse(json["Datum"]).toLocal() : null;
    DateTime createDate = json["KeszitesDatuma"] != null
        ? DateTime.parse(json["KeszitesDatuma"]).toLocal()
        : null;
    String teacher = json["KeszitoTanarNeve"] ?? "";
    DateTime seenDate = json["LattamozasDatuma"] != null
        ? DateTime.parse(json["LattamozasDatuma"]).toLocal()
        : null;
    String groupId = json["OsztalyCsoport"] != null
        ? json["OsztalyCsoport"]["Uid"] ?? ""
        : "";
    String content = json["Tartalom"].replaceAll("\r", "") ?? "";
    Type type = json["Tipus"] != null ? Type.fromJson(json["Tipus"]) : null;

    return Decision(
      id,
      title,
      date,
      createDate,
      teacher,
      seenDate,
      groupId,
      content,
      type,
      json: json,
    );
  }
}
