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

  TradeHistoryPopupWidget({
    this.right = 10,
    this.bottom = 70,
    this.width = 330, //conteinerWidh*itemNum + 10
    this.height = 500,
    required this.tradingHistoryList,
  });

  final EdgeInsets padding = EdgeInsets.all(5);
  final EdgeInsets margin = EdgeInsets.only(top: 5, bottom: 5);
  final double blur = 20;

  @override
  Widget build(BuildContext context) {
    final double containerHeight =
        height / 2 - margin.bottom - margin.top - padding.top - padding.bottom;
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
              height: containerHeight,
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
                    height: containerHeight - 30,
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
              height: 180,
              width: 200,
              margin: EdgeInsets.all((height / 2 - 180) / 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).grayColor,
                ),
              ),
              child: Center(
                child: Container(
                  width: 150,
                  height: 120,
                  child: Column(
                    children: [
                      Row(
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
