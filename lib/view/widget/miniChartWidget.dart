import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/main.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartInfoWidget.dart';

class MiniChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final ChartParams miniChartParams;

  final double dailyCandlestickWidth = 15;
  final double infoWidgetHeight = 20;

  MiniChartWidget({
    required this.width,
    required this.height,
    required this.miniChartParams,
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
            miniChartParams: miniChartParams,
          ),
          Row(
            children: [
              Container(
                width: width - dailyCandlestickWidth,
                height: height - infoWidgetHeight,
                child: Candlesticks(
                  candles: miniChartParams.candles,
                  indicators: [
                    miniChartParams.vwapIndicator,
                    miniChartParams.tickIndicator,
                  ],
                  isMiniChart: true,
                ),
              ),
              DailyCandlestickWidget(
                dailyCandlestick: miniChartParams.dailyCandlestick,
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
