import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  CustomAlertDialog({this.title, this.content, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.none,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: "OpenSans",
        ),
      ),
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                content,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: "OpenSans",
                ),
              ),
            ),
            OutlineButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
