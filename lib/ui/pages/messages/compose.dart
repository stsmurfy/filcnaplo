import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:filcnaplo/data/controllers/search.dart';
import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/attachment.dart';

class NewMessagePage extends StatefulWidget {
  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    _typeAheadController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  List<Recipient> recipientsAll = [];

  Widget searchField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: _typeAheadController,
          decoration: InputDecoration(border: InputBorder.none)),
      suggestionsCallback: (pattern) {
        return SearchController.recipientResults(recipientsAll, pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name ?? ""),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        _typeAheadController.text = "";
        setState(() {
          if (!messageContext.recipients.contains(suggestion))
            messageContext.recipients.add(suggestion);
        });
      },
      hideOnEmpty: true,
      hideOnError: true,
      hideOnLoading: true,
    );
  }

  Widget attachmentTile(File file) {
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
                messageContext.attachments.removeWhere((f) => f.file == file);
              });
            },
          ),
        ],
      ),
    );
  }

  List<Widget> getRecipients() {
    List<Widget> recipients = <Widget>[];

    if (messageContext.recipients != null) {
      messageContext.recipients.forEach((Recipient recipient) {
        recipients.add(
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Chip(
              label: Text(
                recipient.name,
                overflow: TextOverflow.ellipsis,
              ),
              onDeleted: () {
                setState(() {
                  messageContext.recipients
                      .removeWhere((Recipient i) => i.name == recipient.name);
                });
              },
            ),
          ),
        );
      });
    }

    return recipients;
  }

  List<Widget> recipientTiles = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (messageContext.recipients.length == 0) {
      recipientTiles = [];
      recipientTiles.add(searchField());
    } else {
      recipientTiles = getRecipients();
      recipientTiles.add(searchField());
    }

    if (recipientsAll.length == 0) {
      app.user.sync.recipients.sync().then((result) {
        if (result) {
          recipientsAll = app.user.sync.recipients.data;
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              I18n.of(context).error,
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ));
        }
      });
    }

    if (messageContext.subject != null) {
      setState(() {
        subjectController.text = messageContext.subject;
      });
      messageContext.subject = null;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 32.0),
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Back
                    BackButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    Spacer(),

                    // Add Attachments
                    IconButton(
                      icon: Icon(FeatherIcons.paperclip),
                      tooltip: capital(I18n.of(context).messageAttachments),
                      onPressed: () async {
                        try {
                          List<File> files = await FilePicker.getMultiFile();
                          setState(() {
                            for (var i = 0; i < files.length; i++) {
                              File f = files[i];
                              messageContext.attachments.add(
                                Attachment(null, f, f.path.split("/").last,
                                    null, null),
                              );
                            }
                          });
                        } catch (error) {
                          print("ERROR: NewMessagePage.build: " +
                              error.toString());
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                              I18n.of(context).error,
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ));
                        }
                      },
                    ),

                    // Send
                    IconButton(
                      icon: Icon(FeatherIcons.send,
                          color: app.settings.appColor),
                      tooltip: capital(I18n.of(context).messageSend),
                      onPressed: () {
                        sendMessage().then((success) {
                          if (success) {
                            Navigator.of(context).pop();
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
                        });
                      },
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      // Recipients
                      Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 14.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Text(
                                capital(I18n.of(context).messageRecipients),
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: 200.0, maxWidth: 200.0),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    children: recipientTiles,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      // Subject
                      Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 14.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              capital(I18n.of(context).messageSubject),
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: TextField(
                                controller: subjectController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      // Body
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 14.0, right: 14.0),
                          child: TextField(
                            controller: messageController,
                            textAlignVertical: TextAlignVertical.top,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: capital(I18n.of(context).message)),
                          ),
                        ),
                      ),

                      messageContext.attachments.length > 0
                          ? Divider()
                          : Container(),

                      // Attachments
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 200.0),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: messageContext.attachments
                                    .map((f) => attachmentTile(f.file))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendMessage() async {
    messageContext.subject = subjectController.text;
    messageContext.content = messageController.text;

    return await app.user.kreta.sendMessage();
  }
}
