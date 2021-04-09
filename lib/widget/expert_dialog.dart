import 'package:flutter/material.dart';
import 'package:kbc_quiz/widget/button.dart';

class ExpertDialog extends StatelessWidget {
  final String _correctOption;

  ExpertDialog(this._correctOption);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      contentPadding: EdgeInsets.all(30.0),
      elevation: 10.0,
      backgroundColor: Theme.of(context).primaryColor,
      children: <Widget>[
        Text("Expert suggested answer :",
            style: TextStyle(fontSize: 17, color: Theme.of(context).textSelectionColor)),
        SizedBox(
          height: 10,
        ),
        Text(
          "$_correctOption",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textSelectionColor,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Button(
          buttonText: "OK",
          callback: (c) {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

}
