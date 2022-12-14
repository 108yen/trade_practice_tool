import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/main.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartInfoWidget.dart';
import 'package:trade_practice_tool/view/widget/tradeHistoryWidget.dart';

class MiniChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final ChartParams miniChartParams;
  final TradingHistoryList tradingHistoryList;
  final Function onTap;
  final Key key;

  MiniChartWidget({
    required this.key,
    required this.width,
    required this.height,
    required this.miniChartParams,
    required this.tradingHistoryList,
    required this.onTap,
  });

  final double dailyCandlestickWidth = 15;
  final double infoWidgetHeight = 20;
  double? presentValue;

  @override
  Widget build(BuildContext context) {
    if (miniChartParams.currentBord?.askTime != null &&
        DateTime.parse(miniChartParams.currentBord!.askTime!)
                .add(Duration(hours: 9))
                .hour <
            9) {
      presentValue = miniChartParams.currentBord?.askPrice;
    }

    return Container(
      width: width,
      height: height,
      child: GestureDetector(
        child: Column(
          children: [
            MiniChartInfoWidget(
              width: width,
              height: infoWidgetHeight,
              miniChartParams: miniChartParams,
              tradingHistoryList: tradingHistoryList,
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
                    presentValue: presentValue,
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
        onTap: () {
          onTap(miniChartParams.symbol);
        },
      ),
    );
  }
}
