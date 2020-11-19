import 'dart:io';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/attachment.dart';
import 'package:filcnaplo/data/models/kreta_dictionary_item.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExcusePage extends StatefulWidget {
  @override
  _NewExcusePageState createState() => _NewExcusePageState();
}

class _NewExcusePageState extends State<NewExcusePage> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  final TextEditingController justificationController = TextEditingController();
  DateTime start;
  DateTime end;
  KretaDictionaryItem type;
  List<Attachment> attachments = [];
  List<Attachment> requiredAttachments = [];
  List<DropdownMenuItem<KretaDictionaryItem>> tmgiTypes = [];
  bool isAttachmentRequired = false;

  @override
  void dispose() {
    if (mounted) {
      startController.dispose();
      endController.dispose();
      justificationController.dispose();
      super.dispose();
    }
  }

  InputDecoration inputDecoration({String hint}) => InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      fillColor: Colors.black12,
      filled: true,
      contentPadding: EdgeInsets.all(8.0),
      isDense: true,
      hintText: hint);

  Widget attachmentTile(File file, List<Attachment> attachments) {
    return Container(
      padding: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: <Widget>[
          Icon(FeatherIcons.file),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                file.path.split("/").last,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(FeatherIcons.x),
            onPressed: () {
              setState(() {
                attachments.removeWhere((f) => f.file == file);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TMGI types
    if (tmgiTypes.length == 0) {
      app.user.kreta.getTMGITypes().then((types) {
        setState(() {
          types.forEach((type) {
            tmgiTypes.add(DropdownMenuItem<KretaDictionaryItem>(
              value: type,
              child: Text(type.name),
            ));
          });
        });
      });
    }

    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          // Back
                          BackButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                          Spacer(),

                          // Send
                          IconButton(
                            icon: Icon(FeatherIcons.send,
                                color: app.settings.appColor),
                            tooltip: capital(I18n.of(context).messageSend),
                            onPressed: () {
                              /*sendMessage().then((success) {
                                if (success) {
                                  Navigator.pop(context);
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                      I18n.of(context).errorMessageSend,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              });*/
                            },
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(children: [
                                  Expanded(
                                      child: TextField(
                                    readOnly: true,
                                    controller: startController,
                                    decoration:
                                        inputDecoration(hint: "Kezdete"),
                                  )),
                                  IconButton(
                                      icon: Icon(FeatherIcons.calendar),
                                      onPressed: (() {
                                        getDate(
                                                initialDate: start,
                                                lastDate: end)
                                            .then((date) {
                                          if (date != null) {
                                            start = date;
                                            startController.text =
                                                DateFormat('yyyy. MM. dd.')
                                                    .format(date);
                                          }
                                        });
                                      })),
                                  Expanded(
                                      child: TextField(
                                    readOnly: true,
                                    controller: endController,
                                    decoration: inputDecoration(hint: "Vége"),
                                  )),
                                  IconButton(
                                      icon: Icon(FeatherIcons.calendar),
                                      onPressed: (() {
                                        getDate(
                                                initialDate: end,
                                                firstDate: start)
                                            .then((date) {
                                          if (date != null) {
                                            end = date;
                                            endController.text =
                                                DateFormat('yyyy. MM. dd.')
                                                    .format(date);
                                          }
                                        });
                                      })),
                                ]),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.all(8.0),
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    child: DropdownButton(
                                      isDense: true,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      value: type,
                                      hint: Text("Igazolás típusa"),
                                      items: tmgiTypes,
                                      onChanged: (KretaDictionaryItem value) {
                                        setState(() {
                                          type = value;
                                          isAttachmentRequired = [
                                            "ORVOSI",
                                            "HIVATALOS_TAVOLLET",
                                            "SZOLGALTATOI",
                                            "KIKERO"
                                          ].contains(type.code);
                                        });
                                      },
                                    )),
                                TextField(
                                  controller: justificationController,
                                  decoration: inputDecoration(hint: "Indoklás"),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  minLines: 3,
                                ),

                                (isAttachmentRequired
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                            ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  "Kötelező dokumentum"
                                                      .toUpperCase(),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                subtitle: Text(type.name),
                                                trailing: IconButton(
                                                    icon: Icon(
                                                        FeatherIcons.paperclip),
                                                    tooltip: capital(I18n.of(
                                                            context)
                                                        .messageAttachments),
                                                    onPressed: (() {
                                                      _addAttachment(
                                                          requiredAttachments);
                                                    }))),
                                            requiredAttachments.length == 0
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        "Még nincs csatolva dokumentum.",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor)))
                                                : Column(
                                                    children: requiredAttachments
                                                        .map((f) => attachmentTile(
                                                            f.file,
                                                            requiredAttachments))
                                                        .toList(),
                                                  )
                                          ])
                                    : Container()),

                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    (isAttachmentRequired
                                            ? "Egyéb dokumentum"
                                            : "Csatolt dokumentum")
                                        .toUpperCase(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(FeatherIcons.paperclip),
                                      tooltip: capital(
                                          I18n.of(context).messageAttachments),
                                      onPressed: (() {
                                        _addAttachment(attachments);
                                      })),
                                ),

                                // Attachments
                                attachments.length == 0
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                            "Még nincs csatolva dokumentum.",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .hintColor)))
                                    : Column(
                                        children: attachments
                                            .map((f) => attachmentTile(
                                                f.file, attachments))
                                            .toList(),
                                      )
                              ]))
                    ])))));
  }

  Future<DateTime> getDate(
      {DateTime initialDate, DateTime firstDate, DateTime lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(DateTime.now().year - 5),
      lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
    );
  }

  _addAttachment(List<Attachment> attachments) async {
    try {
      List<File> files = await FilePicker.getMultiFile();

      if (files == null)
        return;

      setState(() {
        for (var i = 0; i < files.length; i++) {
          File f = files[i];
          attachments.add(
            Attachment(null, f, f.path.split("/").last, null, null),
          );
        }
      });
    } catch (error) {
      print("ERROR: NewExcusePage.build: " + error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          I18n.of(context).error,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  /*Future<bool> sendMessage() async {
    messageContext.subject = subjectController.text;
    messageContext.content = messageController.text;

    return await app.user.kreta.sendMessage();
  }*/
}
