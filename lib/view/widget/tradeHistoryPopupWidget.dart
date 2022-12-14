import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';
import 'package:trade_practice_tool/view/widget/glassContainer.dart';

class TradeHistoryPopupWidget extends StatelessWidget {
  final double right;
  final double bottom;
  final double width;
  final double height;
  final TradingHistoryList tradingHistoryList;
  final Function onTapCalendar;
  final Function onTapReplay;
  final Function onTapStart;
  final int isolateStatus;
  final String repalyDate;
  final String currentTime;
  final int symbolNum;

  TradeHistoryPopupWidget({
    this.right = 10,
    this.bottom = 70,
    this.width = 330, //conteinerWidh*itemNum + 10
    this.height = 500,
    required this.tradingHistoryList,
    required this.onTapCalendar,
    required this.onTapReplay,
    required this.onTapStart,
    required this.isolateStatus,
    required this.repalyDate,
    required this.currentTime,
    required this.symbolNum,
  });

  final EdgeInsets padding = EdgeInsets.all(5);
  final EdgeInsets margin = EdgeInsets.only(top: 5, bottom: 5);
  final double blur = 20;

  @override
  Widget build(BuildContext context) {
    final double historyListHeight =
        height / 2 - margin.bottom - margin.top - padding.top - padding.bottom;
    final double iconBarHeight = 40;
    final double sumInfoHeight = historyListHeight - iconBarHeight;
    return Positioned(
      right: right,
      bottom: bottom,
      child: GlassContainer(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        blur: 1,
        child: Column(
          children: [
            Container(
              height: historyListHeight,
              margin: margin,
              child: Column(
                children: [
                  Row(
                    children: [
                      ItemContainer('銘柄名'),
                      ItemContainer('購入価格'),
                      ItemContainer('売却価格'),
                      ItemContainer('利益'),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).grayColor,
                    height: 10,
                  ),
                  Container(
                    height: historyListHeight - 30,
                    child: ListView.builder(
                      itemCount: tradingHistoryList.tradingHistoryList.length,
                      itemBuilder: ((context, index) {
                        final tradingHistoryItem =
                            tradingHistoryList.tradingHistoryList[index];
                        return Row(
                          children: [
                            ItemContainer(tradingHistoryItem.symbolName),
                            ItemContainer(
                                tradingHistoryItem.buyValue.toStringAsFixed(0)),
                            ItemContainer(tradingHistoryItem.sellValue
                                    ?.toStringAsFixed(0) ??
                                '(${tradingHistoryItem.plusTwoPerValue.toStringAsFixed(0)})'),
                            ItemContainer(
                              NumberFormat("#,###")
                                  .format(tradingHistoryItem.profit),
                              textColor: tradingHistoryItem.profit < 0
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: sumInfoHeight,
              width: 200,
              margin: margin,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).grayColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ItemContainer(
                            '${repalyDate} ${DateFormat('E').format(DateTime.parse(repalyDate))}',
                            alignment: Alignment.centerLeft,
                            width: 110,
                          ),
                          ItemContainer(
                            '${symbolNum} 銘柄',
                            alignment: Alignment.centerRight,
                            width: 50,
                          ),
                        ],
                      ),
                      ItemContainer(
                        currentTime,
                        alignment: Alignment.centerLeft,
                        width: 160,
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).grayColor,
                    height: 4,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '総資産：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${NumberFormat("#,###").format(tradingHistoryList.originAssets + tradingHistoryList.sumProfit)}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '総利益：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${NumberFormat("#,###").format(tradingHistoryList.sumProfit)}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '総利益率：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${tradingHistoryList.sumProfitRate}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '平均利益：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${NumberFormat("#,###").format(tradingHistoryList.sumProfit / tradingHistoryList.tradingHistoryList.length)}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '平均利益率：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${(tradingHistoryList.sumProfitRate / tradingHistoryList.tradingHistoryList.length).toStringAsFixed(2)}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ItemContainer(
                        '取引数：',
                        alignment: Alignment.centerLeft,
                        width: 90,
                      ),
                      ItemContainer(
                        '${tradingHistoryList.tradingHistoryList.length}',
                        alignment: Alignment.centerRight,
                        width: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: iconBarHeight,
              width: width,
              margin: margin,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        onTapCalendar();
                      },
                      icon: Icon(Icons.calendar_month_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        onTapReplay();
                      },
                      icon: Icon(Icons.replay),
                    ),
                    IconButton(
                      onPressed: () {
                        onTapStart();
                      },
                      icon: Icon(isolateStatus == 0 || isolateStatus == 2
                          ? Icons.play_arrow
                          : Icons.pause),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  final String value;
  final Color textColor;
  final double width;
  final double height;
  final Alignment alignment;

  ItemContainer(this.value,
      {this.textColor = Colors.white,
      this.width = 80,
      this.height = 20,
      this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
