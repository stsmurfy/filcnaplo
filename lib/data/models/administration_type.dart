class AdministrationType {
  int id;
  String code;
  String shortName;
  String name;
  String description;

  AdministrationType(this.id, this.code, this.shortName, this.name, this.description);

  factory AdministrationType.fromJson(Map json) {
    int id = json["azonosito"];
    String code = json["kod"] ?? "";
    String shortName = json["rovidNev"] ?? "";
    String name = json["nev"] ?? "";
    String description = json["leiras"] ?? "";

    return AdministrationType(id, code, shortName, name, description);
  }
}
