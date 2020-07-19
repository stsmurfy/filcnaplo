import 'package:filcnaplo/helpers/debug.dart';
import 'package:filcnaplo/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/generated/i18n.dart';

class DebugSettings extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: Text(I18n.of(context).settingsDebugTitle),
      ),
      body: Container(
        child: Column(children: <Widget>[
          ListTile(
            leading: Icon(FeatherIcons.trash2),
            title: Text(I18n.of(context).settingsDebugDelete),
            onTap: () {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  I18n.of(context).settingsDebugDeleteSuccess,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ));

              DebugHelper().eraseData().then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (_) => false,
                );
              });
            },
          ),
        ]),
      ),
    );
  }
}
