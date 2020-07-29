import 'package:flutter/material.dart';


typedef ResultCallback(String str);
class ResultOperatorWidget extends StatelessWidget {
  final ResultCallback resultCallback;

  const ResultOperatorWidget({Key key, this.resultCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: double.infinity, minWidth: double.infinity),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _widget("C", Colors.lightGreen),
            ),
            Expanded(
              flex: 1,
              child: _widget("<-", Colors.red),
            ),
            Expanded(flex: 2, child: _widget(" = ", Colors.orange))
          ],
        ),
      ),
    );
  }

  Widget _widget(String str, Color colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Ink(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () {
            resultCallback(str);
          },
          borderRadius: BorderRadius.all(Radius.circular(10)),
          highlightColor: colors,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: colors),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            alignment: Alignment.center,
            child: Text(
              str,
              style: TextStyle(color: colors, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
