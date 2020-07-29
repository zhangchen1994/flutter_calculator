import 'package:flutter/material.dart';

typedef Operator(String operator);

class OperatorWidget extends StatelessWidget {
  final Operator operator;
  final List<String> operators = ["+", "-", "×", "÷"];

  OperatorWidget({Key key, this.operator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: double.infinity, minHeight: double.infinity),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _operatorWidget(operators[0], Colors.deepOrange),
            _operatorWidget(operators[1], Colors.greenAccent),
            _operatorWidget(operators[2], Colors.yellow),
            _operatorWidget(operators[3], Colors.lightGreen)
          ],
        ),
      ),
    );
  }
  
  Widget _operatorWidget(String str, Color color) {
    return ClipOval(
      child: Ink(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: InkWell(
          onTap: () {
            operator(str);
          },
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Text(
              str,
              style:
              TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
    );
  }
}
