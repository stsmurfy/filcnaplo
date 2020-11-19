class KretaDictionaryItem {
  int id;
  String code;
  String shortName;
  String name;
  String description;

  KretaDictionaryItem(this.id, this.code, this.shortName, this.name, this.description);

  factory KretaDictionaryItem.fromJson(Map json) {
    int id = json["azonosito"];
    String code = json["kod"] ?? "";
    String shortName = json["rovidNev"] ?? "";
    String name = json["nev"] ?? "";
    String description = json["leiras"] ?? "";

    return KretaDictionaryItem(id, code, shortName, name, description);
  }
}
