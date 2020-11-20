import 'package:filcnaplo/helpers/login.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/login.dart';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';

import 'package:filcnaplo/ui/school_select.dart';
import 'package:filcnaplo/ui/pages/frame.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    loginContext = LoginContext();
    app.settings.update(login: false);

    app.kretaApi.client.getSchools().then((schools) {
      loginContext.schools = schools;
      loginContext.schoolState = true;
    });
  }

  @override
  void dispose() {
    if (mounted) {
      loginUsernameController.dispose();
      loginPasswordController.dispose();
      super.dispose();
    }
  }

  Widget inputIcon({int type}) {
    switch (type) {
      case 1:
        return IconButton(
          icon: Icon(
            loginContext.passwordVisible
                ? FeatherIcons.eyeOff
                : FeatherIcons.eye,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              loginContext.passwordVisible = !loginContext.passwordVisible;
            });
          },
        );
    }
    return null;
  }

  InputDecoration inputDecoration({int type}) {
    return InputDecoration(
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
      contentPadding: EdgeInsets.all(12.0),
      isDense: true,
      suffixIcon: inputIcon(type: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF236A5B),
      body: AutofillGroup(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 0),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                app.users.where((user) => user.loginState).length > 0
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: BackButton(color: Colors.white),
                      )
                    : Container(),

                Spacer(),

                // Hero Logo
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => app.debugMode = true);
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        "Debug mode enabled",
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.grey[900],
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Image.asset("assets/icon.png"),
                    width: 164,
                  ),
                ),

                // Username Input
                Tooltip(
                  message: I18n.of(context).loginUsernameHint,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          capital(I18n.of(context).loginUsername),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Color(0xE0FFFFFF)),
                        decoration: inputDecoration(type: 0),
                        controller: loginUsernameController,
                        autofillHints: [AutofillHints.username],
                      ),
                    ],
                  ),
                ),

                // Username Error Message
                loginContext.loginError["username"] != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(loginContext.loginError["username"],
                            style: TextStyle(color: Colors.orange[600])),
                      )
                    : Container(),

                // Password Input
                Tooltip(
                  message: I18n.of(context).loginPasswordHint,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 12.0, bottom: 6.0),
                        child: Text(
                          capital(I18n.of(context).loginPassword),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextField(
                        style: TextStyle(color: Color(0xE0FFFFFF)),
                        obscureText: !loginContext.passwordVisible,
                        decoration: inputDecoration(type: 1),
                        controller: loginPasswordController,
                        autofillHints: [AutofillHints.password],
                      ),
                    ],
                  ),
                ),

                // Password Error Message
                loginContext.loginError["password"] != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(loginContext.loginError["password"],
                            style: TextStyle(color: Colors.orange[600])),
                      )
                    : Container(),

                // School Selector
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 12.0, bottom: 2.0),
                  child: Text(
                    capital(I18n.of(context).loginSchool),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 999,
                  child: FlatButton(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Text(
                      loginContext.selectedSchool == null
                          ? I18n.of(context).loginChooseSchool
                          : loginContext.selectedSchool.name,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchoolSelect())).then((_) {
                        setState(() {});
                      });
                    },
                  ),
                ),

                // School Error Message
                loginContext.loginError["school"] != null
                    ? Text(loginContext.loginError["school"],
                        style: TextStyle(color: Colors.orange[600]))
                    : Container(),

                SizedBox(height: 24.0),

                // Login Button
                Container(
                  width: 200,
                  child: FlatButton(
                    onPressed: () {
                      setState(() => loading = true);
                      loginContext.loginError = {};
                      loginContext.username = loginUsernameController.text;
                      loginContext.password = loginPasswordController.text;
                      LoginHelper(key: _scaffoldKey).submit(context).then(
                        (bool success) {
                          setState(() => loading = false);

                          if (success) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PageFrame()));

                            // save login details & reset
                            loginContext = LoginContext();
                            loginUsernameController.text = "";
                            loginPasswordController.text = "";
                          }
                        },
                      ).catchError((error) {
                        print("ERROR: LoginPage.submit: " + error.toString());
                        setState(() => loading = false);
                      });
                    },
                    color: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 12.0, 0, 12.0),
                      child: (loading)
                          ? Container(
                              height: 24.0,
                              width: 24.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              capital(I18n.of(context).login),
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.0),
                Spacer(),

                // Version number
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
                    child: Text(
                      (app.debugMode ? "Debug " : "") +
                          "v" +
                          app.currentAppVersion,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  onTap: app.debugMode
                      ? () {
                          setState(() {
                            loginUsernameController.text = "nobody";
                            loginPasswordController.text = "nobody";
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
