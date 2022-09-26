import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class TradeHistoryWidget extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double containerHeight = 20;
  final double containerBorderWidth = 0.3;
  final double padding = 5.0;
  final Function onBuy;
  final TradingHistoryList tradingHistoryList;

  TradeHistoryWidget({
    required this.width,
    required this.height,
    required this.margin,
    required this.onBuy,
    required this.tradingHistoryList,
  });

  @override
  Widget build(BuildContext context) {
    Widget _infoColumn(String index, String info, Color infoColor) {
      return Row(
        children: [
          Container(
            width: 100,
            height: containerHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).grayColor,
                width: containerBorderWidth,
              ),
            ),
            child: Center(child: Text(index)),
          ),
          Container(
            width: width - 100 - padding * 2,
            height: containerHeight,
            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).grayColor,
                width: containerBorderWidth,
              ),
            ),
            child: Text(
              info,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: infoColor,
              ),
            ),
          ),
        ],
      );
    }

    late Color profitColor;
    if (tradingHistoryList.buyFlag &&
        tradingHistoryList
                .tradingHistoryList[
                    tradingHistoryList.tradingHistoryList.length - 1]
                .profit <
            0) {
      profitColor = Colors.red;
    } else {
      profitColor = Colors.white;
    }

    final formatter = NumberFormat("#,###.00");

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: Theme.of(context).background,
      child: Column(
        children: [
          _infoColumn(
            '所持金額合計',
            '${NumberFormat("#,###").format(tradingHistoryList.sumProfit + 1000000)} 円',
            Colors.white,
          ),
          _infoColumn(
            '利益',
            '${NumberFormat("#,###").format(tradingHistoryList.sumProfit)} 円',
            Colors.white,
          ),
          _infoColumn(
            '利益率',
            '${tradingHistoryList.sumProfitRate.toStringAsFixed(2)} %',
            Colors.white,
          ),
          _infoColumn(
            '仮利益',
            '${NumberFormat("#,###").format(tradingHistoryList.buyFlag ? tradingHistoryList.tradingHistoryList[tradingHistoryList.tradingHistoryList.length - 1].profit : 0)} 円',
            profitColor,
          ),
          Container(
            height: containerHeight,
            margin: EdgeInsets.all(padding),
            child: OutlinedButton(
              onPressed: () => onBuy(),
              child: Text('成買'),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
