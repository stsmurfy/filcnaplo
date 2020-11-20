import 'dart:typed_data';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/models/attachment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:filcnaplo/ui/image_viewer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class AttachmentTile extends StatefulWidget {
  AttachmentTile(this.attachment, {Key key}) : super(key: key);

  final Attachment attachment;

  @override
  _AttachmentTileState createState() => new _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  Uint8List data;

  isImage(Attachment attachment) {
    return attachment.name.endsWith(".jpg") ||
        attachment.name.endsWith(".png") ||
        attachment.name.endsWith(".jpeg");
    /* todo: check if it's an image by mime type */
  }

  @override
  initState() {
    var attachment = widget.attachment;
    super.initState();
    if (isImage(attachment)) {
      app.user.kreta.downloadAttachment(this.widget.attachment).then((var d) {
        setState(() {
          data = d;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var attachment = widget.attachment;

    handleShare() async {
      String dir = (await getTemporaryDirectory()).path;
      print(dir);
      File temp = new File('$dir/temp.file.' + attachment.name);
      await temp.writeAsBytes(data);
      await Share.shareFiles(['$dir/temp.file.' + attachment.name]);
      temp.delete();
    }

    handleSave() async {
      saveAttachment(attachment, data).then((String f) => OpenFile.open(f));
    }

    tapImage() {
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => ImageViewer(
              imageProvider: MemoryImage(data),
              shareHandler: handleShare,
              downloadHandler: handleSave)));
    }

    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
      child: FlatButton(
        color: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.only(
          bottom: 12.0,
          top: isImage(attachment) ? 0 : 12.0,
        ),
        onPressed: () {
          if (data != null) {
            saveAttachment(attachment, data)
                .then((String f) => OpenFile.open(f));
          } else {
            downloadAttachment(attachment);
          }
        },
        child: Column(
          children: [
            isImage(attachment)
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: data != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                  child: Material(
                                    child: InkWell(
                                      child: Ink.image(
                                        image: MemoryImage(data),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                      onTap: tapImage,
                                    ),
                                    color: Colors.transparent,
                                  ),
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
                        attachment.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(FeatherIcons.download),
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
Future<String> saveAttachment(
  Attachment attachment,
  Uint8List data,
) async {
  try {
    String downloads;

    if (Platform.isAndroid) {
      downloads = "/storage/self/primary/Download";
    } else {
      downloads = (await getTemporaryDirectory()).path;
    }

    if (data != null) {
      var filePath = downloads + "/" + attachment.name;
      if (app.debugMode) print("INFO: Saved file: " + filePath);
      if (await StorageController.writeFile(filePath, data)) {
        print("Downloaded " + attachment.name);
        return filePath;
      } else {
        throw "Storage Permission denied";
      }
    } else {
      throw "Cannot write null to file";
    }
  } catch (error) {
    print("ERROR: downloadAttachment: " + error.toString());
    return null;
  }
}

Future downloadAttachment(Attachment attachment) async {
  var data = await app.user.kreta.downloadAttachment(attachment);
  saveAttachment(attachment, data).then((String f) => OpenFile.open(f));
}
