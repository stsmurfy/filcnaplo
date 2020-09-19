import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/card.dart';

class Now extends StatefulWidget {
  @override
  NowState createState() => NowState();
}

class NowState extends State<Now> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Hello World - FilcNow"));
  }
}
