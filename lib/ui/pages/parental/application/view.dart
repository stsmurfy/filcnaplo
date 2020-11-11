import 'dart:typed_data';
import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/models/application.dart';
import 'package:filcnaplo/data/models/excuse.dart';
import 'package:filcnaplo/data/models/verdict.dart';
import 'package:filcnaplo/data/models/document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../image_viewer.dart';

class ApplicationView extends StatefulWidget {
  final Application application;

  ApplicationView(this.application);

  @override
  _ApplicationViewState createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Application application;
  Verdict verdict;

  @override
  Widget build(BuildContext context) {
    application = widget.application;

    if (application.verdicts.isNotEmpty) {
      verdict = application.verdicts.first;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          child: CupertinoScrollbar(
        child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
          AppBar(
            centerTitle: true,
            leading: BackButton(),
            title: Text(application.type.code + ' - ' + application.displayName),
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text("Határozat".toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold))),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.settings.theme.backgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verdict == null
                                  ? Text("Még nem született határozat.",
                                      style: TextStyle(fontSize: 16.0))
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text("Döntés",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          Text(verdict.decision.name,
                                              style: TextStyle(fontSize: 16.0)),
                                          SizedBox(height: 10),
                                          Text("Dátum",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          Text(
                                              formatDate(context, verdict.date),
                                              style: TextStyle(fontSize: 16.0)),
                                          SizedBox(height: 10),
                                          Text("Döntés szövege",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          app.settings.renderHtml
                                              ? Html(
                                                  style: {
                                                    "body": Style(
                                                        margin: EdgeInsets.zero,
                                                        fontSize:
                                                            FontSize(16.0))
                                                  },
                                                  data: verdict.content,
                                                  onLinkTap: (url) async {
                                                    if (await canLaunch(url))
                                                      await launch(url);
                                                    else
                                                      throw '[ERROR] ApplicationView.build: Invalid URL';
                                                  },
                                                )
                                              : SelectableLinkify(
                                                  text: escapeHtml(
                                                      verdict.content),
                                                  onOpen: (url) async {
                                                    if (await canLaunch(
                                                        url.url))
                                                      await launch(url.url);
                                                    else
                                                      throw '[ERROR] ApplicationView.build: Invalid URL';
                                                  },
                                                ),
                                          SizedBox(height: 10),
                                          Text("Aláíró neve",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          Text(verdict.signatory.name,
                                              style: TextStyle(fontSize: 16.0)),
                                        ]),
                            ])),
                    (verdict != null ? DocumentTile(verdict.filedVerdict) : Container()),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Kérelem".toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold))),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.settings.theme.backgroundColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kérelem típusa",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(application.type.name,
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Státusz",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(application.status.name,
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Ügyiratszám",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(application.registrationNumber,
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Dátum",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(formatDate(context, application.sendDate),
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Ügyintéző",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(application.administrator.name,
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Tanuló neve",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(
                                  application.studentLastName +
                                      ' ' +
                                      application.studentFirstName,
                                  style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 10),
                              Text("Oktatási azonosító",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              Text(application.studentOM,
                                  style: TextStyle(fontSize: 16.0)),
                              (application is Excuse
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          SizedBox(height: 10),
                                          Text("Igazolás típusa",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          Text(
                                              (application as Excuse)
                                                  .excuseType
                                                  .name,
                                              style: TextStyle(fontSize: 16.0)),
                                          SizedBox(height: 10),
                                          Text("Hiányzás időtartama",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor)),
                                          Text(
                                              formatDate(
                                                      context,
                                                      (application as Excuse)
                                                          .start) +
                                                  " - " +
                                                  formatDate(
                                                      context,
                                                      (application as Excuse)
                                                          .end),
                                              style: TextStyle(fontSize: 16.0))
                                        ])
                                  : null),
                              SizedBox(height: 10),
                              Text("Indoklás",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context).accentColor)),
                              app.settings.renderHtml
                                  ? Html(
                                      style: {
                                        "body": Style(
                                            margin: EdgeInsets.zero,
                                            fontSize: FontSize(16.0))
                                      },
                                      data: application.justification.length > 0
                                          ? application.justification
                                          : "-",
                                      onLinkTap: (url) async {
                                        if (await canLaunch(url))
                                          await launch(url);
                                        else
                                          throw '[ERROR] ApplicationView.build: Invalid URL';
                                      },
                                    )
                                  : SelectableLinkify(
                                      text: escapeHtml(
                                          application.justification.length > 0
                                              ? application.justification
                                              : "-"),
                                      onOpen: (url) async {
                                        if (await canLaunch(url.url))
                                          await launch(url.url);
                                        else
                                          throw '[ERROR] ApplicationView.build: Invalid URL';
                                      },
                                    ),
                            ])),
                    DocumentTile(application.filedApplication)
                  ])),
        ]),
      )),
    );
  }
}

class DocumentTile extends StatefulWidget {
  final Document document;

  DocumentTile(this.document, {Key key}) : super(key: key);

  @override
  _DocumentTileState createState() => new _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  Uint8List data;

  isImage(Document document) {
    return document.name.endsWith(".jpg") || document.name.endsWith(".png");
    /* todo: check if it's an image by mime type */
  }

  @override
  initState() {
    super.initState();

    if (isImage(widget.document)) {
      app.user.kreta.downloadDocument(widget.document).then((var d) {
        setState(() {
          data = d;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handleShare() async {
      String dir = (await getTemporaryDirectory()).path;
      print(dir);
      File temp = new File('$dir/temp.file.' + widget.document.name);
      await temp.writeAsBytes(data);
      await Share.shareFiles(['$dir/temp.file.' + widget.document.name]);
      temp.delete();
    }

    handleSave() async {
      //saveAttachment(attachment, data).then((String f) => OpenFile.open(f));
    }

    tapImage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageViewer(
              imageProvider: MemoryImage(data),
              shareHandler: handleShare,
              downloadHandler: handleSave)));
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Container(
        child: Column(
          children: [
            isImage(widget.document)
                ? Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    child: data != null
                        ? Ink.image(
                      image: MemoryImage(data),
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      child: InkWell(onTap: tapImage),
                    )
                        : Center(
                      child: Container(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            )
                : Container(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: Row(
                children: <Widget>[
                  Icon(FeatherIcons.file),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        widget.document.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.download),
                    onPressed: () {
                      if (data != null) {
                        saveDocument(widget.document, data)
                            .then((String f) => OpenFile.open(f));
                      } else {
                        downloadDocument(widget.document);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// todo: error handling (snackbar)
Future<String> saveDocument(
    Document document,
    Uint8List data,
    ) async {
  try {
    String downloads = (await DownloadsPathProvider.downloadsDirectory).path;

    if (data != null) {
      var filePath = downloads + "/" + document.name.replaceAll('/', '_');
      print("File: " + filePath);
      if (await StorageController.writeFile(filePath, data)) {
        print("Downloaded " + document.name);
        return filePath;
      } else {
        throw "Storage Permission denied";
      }
    } else {
      throw "Cannot write null to file";
    }
  } catch (error) {
    print("ERROR: downloadAttachment: " + error.toString());
  }
}

Future downloadDocument(Document document) async {
  var data = await app.user.kreta.downloadDocument(document);
  saveDocument(document, data).then((String f) => OpenFile.open(f));
}