import 'package:flutter/material.dart';

class ResultTextWidget extends StatelessWidget {
  final String text;

  const ResultTextWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.lightBlue,
      child: Container(
        alignment: Alignment.bottomRight,
        child: Text(
          text,
          softWrap: false,
          overflow: TextOverflow.fade,
          textScaleFactor: 11.0 / text.length > 1.0?1.0:11.0 / text.length,
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
