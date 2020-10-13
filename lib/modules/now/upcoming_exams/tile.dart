import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
class UpcomingExamTile extends StatelessWidget {
  final String description;
  final DateTime writeDate;
  UpcomingExamTile(this.description, this.writeDate);
  Widget build(BuildContext context) {
    return Text(description + " (" + formatDate(context, writeDate) + ")");
  }
}