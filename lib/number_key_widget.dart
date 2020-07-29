import 'dart:ffi';

import 'package:flutter/material.dart';

typedef NumberCallback(String number);
double _childAspectRatio = -1;
class NumberKeyWidget extends StatelessWidget {
  final NumberCallback numberCallback;

  final List<String> numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    ".",
    "%"
  ];
  NumberKeyWidget({Key key, this.numberCallback}) : super(key: key);

  Future<double> getWidgetHeight(BuildContext context) async {
    return await Future.delayed(Duration(milliseconds: 0), () {
      return context.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    var d = MediaQuery.of(context).size.width / 3;
    getWidgetHeight(context).then((value) => {print('v = $value')});
    print('_c = $_childAspectRatio');
    return _childAspectRatio == -1? _widget(context, d): _childWidget(_childAspectRatio);
  }
  
  Widget _widget(BuildContext context, double d) {
    return FutureBuilder<double>(
        future: getWidgetHeight(context),
        builder: (context, snp) {
          double ration = 1.7;
          if (snp.connectionState == ConnectionState.done) {
            double dh = snp.data / 4.0;
            ration = d / dh;
            _childAspectRatio = ration;
          }
          return _childWidget(ration);
        });
  }
  
  Widget _childWidget(double ration) {
    return Material(
      color: Colors.white,
      child: GridView.builder(
          itemCount: numbers.length,
          padding: EdgeInsets.all(0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: ration),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                numberCallback(numbers[index]);
              },
              child: Container(
                child: Text(
                  numbers[index],
                  style: TextStyle(fontSize: 20),
                ),
                alignment: Alignment.center,
              ),
            );
          }),
    );
  }
}
