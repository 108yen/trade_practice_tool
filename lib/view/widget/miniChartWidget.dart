import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/main.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';

class MiniChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<Candle> candles;
  final List<IndicatorComponentData> indicators;
  final DailyCandlestick dailyCandlestick;

  final double dailyCandlestickWidth = 15;

  MiniChartWidget({
    required this.width,
    required this.height,
    required this.candles,
    required this.dailyCandlestick,
    required this.indicators,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Row(
        children: [
          SizedBox(
            width: width - dailyCandlestickWidth,
            height: height,
            child: Candlesticks(
              candles: candles,
              indicators: indicators,
            ),
          ),
          DailyCandlestickWidget(
            dailyCandlestick: dailyCandlestick,
            width: dailyCandlestickWidth,
            height: height,
          ),
        ],
      ),
    );
  }
}
