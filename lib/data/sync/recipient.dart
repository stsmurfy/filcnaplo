import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class RecipientSync {
  List<Recipient> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Recipient> recipients;
      recipients = await app.user.kreta.getRecipients();

      if (recipients == null) {
        await app.user.kreta.refreshLogin();
        recipients = await app.user.kreta.getRecipients();
      }

      if (recipients != null) {
        data = recipients;
        return true;
      } else {
        return false;
      }
    } else {
      data = Dummy.recipients;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
