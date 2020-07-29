import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttercalculator/ResultTextWidget.dart';
import 'package:fluttercalculator/number_key_widget.dart';
import 'package:fluttercalculator/operator_widget.dart';
import 'package:fluttercalculator/result_bean.dart';
import 'package:fluttercalculator/result_operator_widget.dart';
import 'package:fluttercalculator/result_process_widget.dart';

class HomePageRoute extends StatefulWidget {
  @override
  _HomePageRouteState createState() => _HomePageRouteState();
}

class _HomePageRouteState extends State<HomePageRoute> {
  var xss = "";
  StateSetter setter;
  String content;
  static String values = "";
  ValueNotifier<String> _valueNotifier = ValueNotifier(values);
  List<ResultBean> _resultBeans;
  ResultBean _resultBean;
  bool _isContinuity = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _resultBeans = [];
    _resultBean = ResultBean();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: double.infinity, minHeight: double.infinity),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: ResultTextWidget(
                  text: xss,
                )),
            Expanded(
              flex: 1,
              child: ResultProcessWidget(
                valueNotifier: _valueNotifier,
                resultBean: _resultBeans,
              ),
            ),
            Expanded(
              flex: 5,
              child: NumberKeyWidget(
                numberCallback: (number) {
                  if (!_resultBeans.contains(_resultBean)) {
                    setState(() {
                      _resultBeans.insert(0, _resultBean);
                    });
                  }
                  _isContinuity = false;
                  _resultBean.tempEx += number;
                  _resultBean.expression = _resultBean.expression + number;
                  _valueNotifier.value = _resultBean.expression;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: OperatorWidget(
                operator: (o) {
                  if (!_resultBeans.contains(_resultBean)) {
                    return;
                  }
                  if (_isContinuity) {
                    return;
                  }
                  _resultBean.numbers.add(_resultBean.tempEx);
                  _resultBean.operator.add(o);
                  _resultBean.tempEx = "";
                  _resultBean.expression += o;
                  _valueNotifier.value = _resultBean.expression;
                  _isContinuity = true;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ResultOperatorWidget(
                resultCallback: (str) {
                  switch (str) {
                    case "C":
                      setState(() {
                        _resultBean = ResultBean();
                        _resultBeans.clear();
                        xss = "";
                      });
                      break;
                    case "<-":
                      if (_resultBean.expression.length < 1) {
                        return;
                      }
                      String str = _resultBean
                          .expression[_resultBean.expression.length - 1];
                      _resultBean.expression =
                          _resultBean.expression.substring(0, _resultBean.expression.length - 1);
                      _valueNotifier.value = _resultBean.expression;
                      if (operators.contains(str)) {
                        _isContinuity = false;
                        _resultBean.tempEx = _resultBean.numbers[_resultBean.numbers.length - 1];
                        _resultBean.operator.remove(str);
                      } else {
                        _resultBean.tempEx = _resultBean.tempEx.substring(0, _resultBean.tempEx.length - 1);
                      }

                      if (_resultBean.expression.isEmpty) {
                        setState(() {
                          _resultBeans.remove(_resultBean);
                          _resultBean = ResultBean();
                        });
                      }
                      break;
                    case " = ":
                      _resultBean.numbers.add(_resultBean.tempEx);
                      _resultBean.tempEx = "";
                      String result = startOperation(_resultBean);
                      setState(() {
                        xss = result;
                      });
                      _resultBean = ResultBean();
                      break;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String startOperation(ResultBean resultBean) {
    if (resultBean.operator.length == resultBean.numbers.length) {
      return "error! ";
    }

    print(resultBean.toString());

    if (resultBean.operator.length == 0) {
      return resultBean.expression;
    }

    double result = 0;
    try {
      List<int> operator = [];
      for (int i = 0; i < resultBean.operator.length; i++) {
        if (resultBean.operator[i] == "×" || resultBean.operator[i] == "÷") {
          operator.add(i);
        }
      }

      List<double> listResult = [];
      //计算乘除
      int lastInt = -10;
      for (int i = 0; i < resultBean.operator.length; i++) {
        if (!operator.contains(i)) {
          continue;
        }

        String num0Str = resultBean.numbers[i];
        //如过计算的两个数是连续在一起的，需要将上一个结果当作此次计算的数。
        if (lastInt == i - 1) {
          num0Str = listResult[listResult.length - 1].toString();
        }

        String num1Str = resultBean.numbers[i + 1];

        double num0;
        if (num0Str.endsWith("%")) {
          num0 = double.parse(num0Str.replaceAll("%", "")) / 100;
        } else {
          num0 = double.parse(num0Str);
        }
        double num1;
        if (num1Str.endsWith("%")) {
          num1 = double.parse(num1Str.replaceAll("%", "")) / 100;
        } else {
          num1 = double.parse(num1Str);
        }

        result = operation(num0, num1, resultBean.operator[i]);
        listResult.add(result);
        lastInt = i;
      }

      print(listResult.toString());

      for (int i = operator.length - 1; i >= 0; i--) {
        resultBean.numbers.removeAt(operator[i] + 1);
        resultBean.numbers.removeAt(operator[i]);
        resultBean.operator.removeAt(operator[i]);

        resultBean.numbers.insert(operator[i], listResult[i].toString());
      }

      //print(resultBean);

      //再计算加减
      for (int i = 0; i < resultBean.operator.length; i++) {
        String num0Str = resultBean.numbers[0];
        String num1Str = resultBean.numbers[1];

        double num0;
        if (num0Str.endsWith("%")) {
          num0 = double.parse(resultBean.numbers[0].replaceAll("%", "")) / 100;
        } else {
          num0 = double.parse(resultBean.numbers[0]);
        }
        double num1;
        if (num1Str.endsWith("%")) {
          num1 = double.parse(resultBean.numbers[1].replaceAll("%", "")) / 100;
        } else {
          num1 = double.parse(resultBean.numbers[1]);
        }

        result = operation(num0, num1, resultBean.operator[i]);

        resultBean.numbers.removeAt(1);
        resultBean.numbers.removeAt(0);
        resultBean.numbers.insert(0, result.toString());
      }
      return result.toString();
    } catch (e) {
      print('e = {$e}');
      return "error!";
    }
  }

  List<String> operators = ["+", "-", "×", "÷"];

  double operation(double n0, double n1, String o) {
    switch (o) {
      case "+":
        return n0 + n1;
        break;
      case "-":
        return n0 - n1;
        break;
      case "×":
        return n0 * n1;
        break;
      case "÷":
        return n0 / n1;
        break;
    }
    return 0;
  }
}
