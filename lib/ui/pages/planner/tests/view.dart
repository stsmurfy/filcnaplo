import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/test.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class TestView extends StatelessWidget {
  final Test test;

  TestView(this.test);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: ProfileIcon(name: test.teacher),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    capitalize(test.teacher),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(formatDate(context, test.date))
              ],
            ),
            subtitle: Text(capital(test.subjectName)),
          ),

          // Test details
          Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                test.description != ""
                    ? TestDetail(
                        I18n.of(context).evaluationDescription,
                        test.description,
                      )
                    : Container(),
                test.writeDate != null
                    ? TestDetail(
                        I18n.of(context).evaluationWriteDate,
                        formatDate(context, test.writeDate),
                      )
                    : Container(),
                test.mode != null
                    ? TestDetail(
                        I18n.of(context).evaluationType,
                        test.mode.description,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestDetail extends StatelessWidget {
  final String title;
  final String value;

  TestDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
