import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class CandleInfoText extends StatelessWidget {
  const CandleInfoText({
    Key? key,
    required this.candle,
  }) : super(key: key);

  final Candle candle;

  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  String dateFormatter(DateTime date) {
    return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)} ${numberFormat(date.hour)}:${numberFormat(date.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: dateFormatter(candle.date),
        style: TextStyle(color: Theme.of(context).grayColor, fontSize: 10),
        children: <TextSpan>[
          TextSpan(text: " O:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.open),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryRed
                      : Theme.of(context).primaryGreen)),
          TextSpan(text: " H:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.high),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryRed
                      : Theme.of(context).primaryGreen)),
          TextSpan(text: " L:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.low),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryRed
                      : Theme.of(context).primaryGreen)),
          TextSpan(text: " C:"),
          TextSpan(
              text: HelperFunctions.priceToString(candle.close),
              style: TextStyle(
                  color: candle.isBull
                      ? Theme.of(context).primaryRed
                      : Theme.of(context).primaryGreen)),
        ],
      ),
    );
  }
}
