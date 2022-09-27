import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/utils/candlesticks/candlesticks.dart';
import 'package:trade_practice_tool/view/widget/bordWidget.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';
import 'package:trade_practice_tool/view/widget/stepWidget.dart';
import 'package:trade_practice_tool/view/widget/tickVolumeWidget.dart';
import 'package:trade_practice_tool/view/widget/tradeHistoryWidget.dart';

class DetailChartWidget extends StatelessWidget {
  final ChartParams chartParams;
  final Function onBackTap;
  final TradingHistoryList tradingHistoryList;
  final Function onBuy;

  DetailChartWidget({
    required this.chartParams,
    required this.onBackTap,
    required this.tradingHistoryList,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    late String currentTime;
    if (chartParams.currentBord?.currentPriceTime != null) {
      currentTime =
          chartParams.currentBord!.currentPriceTime!.substring(11, 19);
    } else {
      currentTime = '';
    }
    late String timestamp;
    if (chartParams.currentBord?.timeStamp != null) {
      timestamp = DateFormat('HH:mm:ss.sss')
          .format(chartParams.currentBord!.timeStamp!);
    } else {
      timestamp = '';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${chartParams.symbol} ${chartParams.symbolName} ${currentTime} ${timestamp}',
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              onBackTap();
            }),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double tickVolumeWidgetHeight = 100;
          final double chartWidth = constraints.maxWidth - 20 - 200 - 250;
          return Row(
            children: [
              // チャート
              Column(
                children: [
                  SizedBox(
                    width: chartWidth,
                    height: constraints.maxHeight - tickVolumeWidgetHeight,
                    child: Candlesticks(
                      candles: chartParams.candles,
                      indicators: [
                        chartParams.tickIndicator,
                        chartParams.vwapIndicator,
                      ],
                      isMiniChart: false,
                    ),
                  ),
                  TickVolumeWidget(
                      steps: chartParams.steps,
                      widgetWidth: chartWidth,
                      widgetHeight: tickVolumeWidgetHeight),
                ],
              ),
              DailyCandlestickWidget(
                dailyCandlestick: chartParams.dailyCandlestick,
                width: 20,
                height: constraints.maxHeight,
              ),
              StepWidget(
                steps: chartParams.steps,
                height: constraints.maxHeight,
              ),
              // 取引履歴と板　width:250
              Column(children: [
                TradeHistoryWidget(
                  width: 250,
                  height: 120,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  tradingHistoryList: tradingHistoryList,
                  onBuy: () => onBuy(),
                ),
                chartParams.currentBord == null
                    ? Text('no data')
                    : BordWidget(
                        bord: chartParams.currentBord!,
                        priviousBord: chartParams.previousBord,
                        height: constraints.maxHeight - 130,
                      ),
              ]),
            ],
          );
        },
      ),
    );
  }
}
