import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';

class AverageCalculator extends StatefulWidget {
  @override
  AverageCalculatorState createState() => AverageCalculatorState();
}

class AverageCalculatorState extends State<AverageCalculator> {
  int evaluation = 1;
  int weight;
  bool isWeight = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: app.settings.theme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 35),
                    child: Text(
                      "Ha kapnék egy...",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      evalRadio(1),
                      evalRadio(2),
                      evalRadio(3),
                      evalRadio(4),
                      evalRadio(5)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: isWeight,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (value) {
                            setState(() {
                              isWeight = value;
                            });
                          },
                        ),
                        Text(
                          "Súly:",
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          width: 60,
                          height: 20,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: TextField(
                            maxLines: 1,
                            autocorrect: false,
                            enabled: isWeight,
                            decoration: InputDecoration(
                                suffix: Text("%"), hintText: "200"),
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, right: 35, left: 35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      "Hozzáadás",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                    color: Theme.of(context).accentColor,
                  )
                ])));
  }

  Widget evalRadio(int value) {
    return Column(
      children: <Widget>[
        Radio<int>(
          value: value,
          groupValue: evaluation,
          activeColor: Theme.of(context).accentColor,
          onChanged: (int value) {
            setState(() {
              evaluation = value;
            });
          },
        ),
        Text(
          value.toString(),
          style: TextStyle(fontSize: 17),
        )
      ],
    );
  }
}
