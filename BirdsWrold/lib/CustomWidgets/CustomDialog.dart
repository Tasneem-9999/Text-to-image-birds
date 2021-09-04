import 'package:flutter/material.dart';

class CustomDialog {
  static showAlertDialog(BuildContext context,
      String titleText, Widget contentWidget,Widget okButton) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titleText),
      content: contentWidget,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static showIndicator(BuildContext context,
      String titleText, Widget contentWidget,Widget okButton) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text(titleText),
      content: Container(
          width: 100,
          height: MediaQuery.of(context).size.height*0.08,
          child: Center(child: contentWidget))  , actions: [
      okButton,
      ],

    );

    // show the dialog
    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
