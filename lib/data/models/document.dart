class Document {
  int id;
  String name;
  String registrationNumber;
  Map json;
  String kretaFilePath;

  Document(
      this.id,
      this.name,
      this.registrationNumber,
      this.kretaFilePath, {
        this.json,
      });

  factory Document.fromJson(Function apiPath, Map json) {
    int id = json["azonosito"];
    String name = json["fajlNev"];
    String registrationNumber = json["iktatoszam"];

    return Document(
      id,
      name,
      registrationNumber,
      apiPath(id.toString()),
      json: json,
    );
  }
}
