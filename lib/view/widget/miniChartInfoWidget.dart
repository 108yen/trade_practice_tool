import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class MiniChartInfoWidget extends StatelessWidget {
  final double width;
  final double height;
  final ChartParams miniChartParams;
  final double titleWidth = 110;
  final TradingHistoryList tradingHistoryList;

  MiniChartInfoWidget({
    required this.width,
    required this.height,
    required this.miniChartParams,
    required this.tradingHistoryList,
  });

  @override
  Widget build(BuildContext context) {
    Color changePreviousClosePerColor = Colors.white;
    if (miniChartParams.currentBord?.changePreviousClosePer != null) {
      changePreviousClosePerColor =
          miniChartParams.currentBord!.changePreviousClosePer! < 0
              ? Theme.of(context).primaryGreen
              : Theme.of(context).primaryRed;
    }
    Color indicatorColor = Theme.of(context).background;
    if (tradingHistoryList.buyFlag &&
        tradingHistoryList
                .tradingHistoryList[
                    tradingHistoryList.tradingHistoryList.length - 1]
                .symbol ==
            miniChartParams.symbol) {
      if (tradingHistoryList
              .tradingHistoryList[
                  tradingHistoryList.tradingHistoryList.length - 1]
              .profit >=
          0) {
        indicatorColor = Theme.of(context).primaryRed;
      } else {
        indicatorColor = Theme.of(context).primaryGreen;
      }
    }

    return Container(
      width: width,
      height: height,
      child: Row(
        children: [
          Container(
            width: titleWidth - 2,
            height: height - 2,
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            color: Theme.of(context).background,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Theme.of(context).grayColor,
            //   ),
            // ),
            child: Text(
              '${miniChartParams.symbol} ${miniChartParams.symbolName}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: width - titleWidth - 2,
            height: height - 2,
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            color: Theme.of(context).background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: height - 10,
                  height: height - 10,
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: indicatorColor,
                  ),
                ),
                Container(
                  width: 50,
                  child: Text(
                    '${miniChartParams.currentBord?.currentPriceTime?.substring(11, 19) ?? ''}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Spacer(),
                Container(
                  width: 40,
                  child: Text(
                    '${miniChartParams.currentBord?.currentPrice ?? ''}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  width: 70,
                  child: Text(
                    '${miniChartParams.currentBord?.changePreviousClosePer ?? ''} %',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: changePreviousClosePerColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
