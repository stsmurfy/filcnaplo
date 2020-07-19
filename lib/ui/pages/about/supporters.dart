import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class AboutSupporters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(I18n.of(context).aboutSupporters),
      ),
    );
  }
}
