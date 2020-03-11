import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Functions {
  static String formatDoubleToMoney(double valor) {
    return FlutterMoneyFormatter(amount: valor).output.nonSymbol.toString();
  }
}
