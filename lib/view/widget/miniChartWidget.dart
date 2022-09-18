import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/main.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartInfoWidget.dart';

class MiniChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<Candle> candles;
  final List<IndicatorComponentData> indicators;
  final DailyCandlestick dailyCandlestick;
  final Bord? bord;

  final double dailyCandlestickWidth = 15;
  final double infoWidgetHeight = 20;

  MiniChartWidget({
    required this.width,
    required this.height,
    required this.candles,
    required this.dailyCandlestick,
    required this.indicators,
    required this.bord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          MiniChartInfoWidget(
            width: width,
            height: infoWidgetHeight,
            bord: bord,
          ),
          Row(
            children: [
              Container(
                width: width - dailyCandlestickWidth,
                height: height - infoWidgetHeight,
                child: Candlesticks(
                  candles: candles,
                  indicators: indicators,
                ),
              ),
              DailyCandlestickWidget(
                dailyCandlestick: dailyCandlestick,
                width: dailyCandlestickWidth,
                height: height - infoWidgetHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
