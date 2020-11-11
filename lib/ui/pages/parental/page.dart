import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/parental/application/builder.dart';
import 'package:filcnaplo/ui/pages/parental/tabs.dart';

class ParentalPage extends StatefulWidget {
  final _scaffoldKey;

  ParentalPage(this._scaffoldKey);

  @override
  _ParentalPageState createState() => _ParentalPageState(this._scaffoldKey);
}

class _ParentalPageState extends State<ParentalPage> {
  ApplicationBuilder _applicationBuilder;

  _ParentalPageState(_scaffoldKey) {
    this._applicationBuilder = ApplicationBuilder();
  }

  @override
  Widget build(BuildContext context) {
    buildPage();

    return ParentalTabs(
      widget._scaffoldKey,
      _applicationBuilder.applicationTiles,
      callback: updateCallback,
    );
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    _applicationBuilder.build();
  }
}
