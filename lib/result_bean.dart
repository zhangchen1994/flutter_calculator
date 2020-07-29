
class ResultBean {
  String expression = "";
  String tempEx = "";
  List<String> numbers = [];
  List<String> operator = [];

  @override
  String toString() {
    return 'ResultBean{expression: $expression, tempEx: $tempEx, numbers: $numbers, operator: $operator}';
  }
}