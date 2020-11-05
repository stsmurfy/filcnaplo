import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/attachment.dart';

class Application {
  int id;
  int replyId;
  int messageId;
  int conversationId;
  bool seen;
  bool deleted;
  DateTime date;
  String sender;
  String content;
  String subject;
  List<Recipient> recipients;
  List<Attachment> attachments;
  Map json;

  Application(
      this.id,
      this.messageId,
      this.seen,
      this.deleted,
      this.date,
      this.sender,
      this.content,
      this.subject,
      this.recipients,
      this.attachments, {
        this.replyId,
        this.conversationId,
        this.json,
      });

  factory Application.fromJson(Map json) {
    Map message = json["uzenet"];

    int id = message["azonosito"] ?? 0;
    int messageId = message["azonosito"];
    int replyId = message["elozoUzenetAzonosito"];
    int conversationId = message["beszelgetesAzonosito"];
    bool seen = json["isElolvasva"] ?? false;
    bool deleted = json["isToroltElem"] ?? false;
    DateTime date = message["utolsoModositasDatum"] != null
        ? DateTime.parse(message["utolsoModositasDatum"]).toLocal()
        : null;
    DateTime submissionDate = message["bekuldesDatum"] != null
        ? DateTime.parse(message["bekuldesDatum"]).toLocal()
        : null;
    String sender = message["feladoNev"] ?? "";
    String content = message["szoveg"].replaceAll("\r", "") ?? "";
    String subject = message["targy"] ?? "";

    List<Recipient> recipients = [];
    List<Attachment> attachments = [];

    message["cimzettLista"].forEach((recipient) {
      recipients.add(Recipient.fromJson(recipient));
    });

    message["csatolmanyok"].forEach((attachment) {
      attachments.add(Attachment.fromJson(attachment));
    });

    return Application(
      id,
      messageId,
      seen,
      deleted,
      date,
      sender,
      content,
      subject,
      recipients,
      attachments,
      replyId: replyId,
      conversationId: conversationId,
      json: json,
    );
  }

  bool compareTo(dynamic other) {
    if (this.runtimeType != other.runtimeType) return false;

    if (this.id == other.id &&
        this.seen == other.seen &&
        this.deleted == other.deleted) {
      return true;
    }

    return false;
  }
}
