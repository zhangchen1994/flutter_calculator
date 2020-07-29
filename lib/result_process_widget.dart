import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttercalculator/result_bean.dart';

class ResultProcessWidget extends StatelessWidget {
  final List<ResultBean> resultBean;
  final ValueNotifier<String> valueNotifier;

  const ResultProcessWidget({Key key, this.valueNotifier, this.resultBean})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    ListWidget widget = ListWidget(
      valueNotifier: valueNotifier,
      controller: _controller,
    );

    Widget listView = ListView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return index == 0
            ? widget
            : ContainerText(
                color: getRandomColor(text: resultBean[index].expression),
                text: resultBean[index].expression,
              );
      },
      itemCount: resultBean.length,
      scrollDirection: Axis.horizontal,
      reverse: true,
    );

    valueNotifier.addListener(() {
      if (_controller.hasClients) {
        _controller.animateTo(_controller.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
    return Material(
      color: Colors.grey,
      child: Container(
        child: listView,
      ),
    );
  }
}

List<String> operators = ["+", "-", "×", "÷"];

Color getRandomColor({String text}) {
  if (text == null) {
    return Colors.white60;
  }

  if (text.contains(operators[0])) {
    return Colors.deepOrange;
  }

  if (text.contains(operators[1])) {
    return Colors.greenAccent;
  }

  if (text.contains(operators[2])) {
    return Colors.yellow;
  }

  if (text.contains(operators[3])) {
    return Colors.lightGreen;
  }

  return Colors.white60;
}

class ListWidget extends StatefulWidget {
  final ValueNotifier<String> valueNotifier;
  final ScrollController controller;

  const ListWidget({Key key, this.valueNotifier, this.controller})
      : super(key: key);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  VoidCallback _listener;
  Color _color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _color = getRandomColor(text: widget.valueNotifier.value);
    print('color = $_color');
    print('${widget.valueNotifier}');
    _listener = () {
      print('${widget.valueNotifier.value}');
      _color = getRandomColor(text: widget.valueNotifier.value);
      setState(() {});
    };
    widget.valueNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.valueNotifier.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return ContainerText(
      color: _color,
      text: widget.valueNotifier.value,
    );
  }
}

class ContainerText extends StatelessWidget {
  final Color color;
  final String text;

  const ContainerText({Key key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black54),
      ),
    );
  }
}
