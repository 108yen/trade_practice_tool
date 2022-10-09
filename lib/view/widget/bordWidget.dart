import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/assets/infoUtils.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class BordWidget extends StatelessWidget {
  final Bord bord;
  final Bord? priviousBord;
  final TradingHistoryList tradingHistoryList;
  final double width = 250;
  final double height;
  final double containerWidth = 80;
  final double containerHeignt = 20;
  final double containerBorderWidth = 0.3;

  BordWidget({
    required this.bord,
    required this.priviousBord,
    required this.tradingHistoryList,
    this.height = 873,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _calcBordValueList() {
      List<Widget> _bordTickList = [];
      List<double> _bordValueList = [];
      if (bord.buy1.price != null && bord.sell1.price != null) {
        final ave = (bord.buy1.price! + bord.sell1.price!) / 2;
        final medianTickRange = getTickRange(ave);
        final median = medianTickRange * (ave ~/ medianTickRange);

        int valueState = 0;
        _bordValueList.add(median);
        if (median == bord.currentPrice) {
          valueState = 3;
        }
        if (median == bord.buy1.price!) {
          _bordTickList.add(Row(
            children: [
              _BordContainer(
                context: context,
              ),
              _BordContainer(
                context: context,
                value: median,
                valueState: valueState,
                textColor: Colors.red,
              ),
              _BordContainer(
                context: context,
                value: bord.buy1.qty,
                textColor: Colors.red,
              ),
            ],
          ));
        } else if (median == bord.sell1.price!) {
          _bordTickList.add(Row(
            children: [
              _BordContainer(
                context: context,
                value: bord.sell1.qty,
                textColor: Colors.blue,
              ),
              _BordContainer(
                context: context,
                value: median,
                valueState: valueState,
                textColor: Colors.blue,
              ),
              _BordContainer(
                context: context,
              ),
            ],
          ));
        } else {
          _bordTickList.add(Row(
            children: [
              _BordContainer(
                context: context,
              ),
              _BordContainer(
                context: context,
                value: median,
              ),
              _BordContainer(
                context: context,
              ),
            ],
          ));
        }
        final List<Qty> _buyList = [
          bord.buy1,
          bord.buy2,
          bord.buy3,
          bord.buy4,
          bord.buy5,
          bord.buy6,
          bord.buy7,
          bord.buy8,
          bord.buy9,
          bord.buy10,
        ];
        final List<Qty> _sellList = [
          bord.sell1,
          bord.sell2,
          bord.sell3,
          bord.sell4,
          bord.sell5,
          bord.sell6,
          bord.sell7,
          bord.sell8,
          bord.sell9,
          bord.sell10,
        ];
        //買い板
        final buySymbol = tradingHistoryList.getBuySymbol();
        for (var i = 0; i < 20; i++) {
          final value = _bordValueList[i] - getTickRange(_bordValueList[i] - 1);
          _bordValueList.add(value);
          int index = _buyList.indexWhere(
              (element) => element.price != null && element.price == value);

          int valueState = 0;
          if (buySymbol != null &&
              buySymbol == bord.symbol &&
              tradingHistoryList
                      .tradingHistoryList[
                          tradingHistoryList.tradingHistoryList.length - 1]
                      .minusThreePerValue ==
                  value) {
            valueState = 2;
          } else if (value == bord.currentPrice) {
            valueState = 3;
          }
          if (index != -1) {
            _bordTickList.add(Row(
              children: [
                _BordContainer(
                  context: context,
                ),
                _BordContainer(
                  context: context,
                  value: value,
                  valueState: valueState,
                  textColor: index != 0 ? Colors.white : Colors.red,
                ),
                _BordContainer(
                  context: context,
                  value: index != 0
                      ? _buyList[index].qty
                      : '${_buyList[index].qty}',
                  textColor: Colors.red,
                ),
              ],
            ));
          } else {
            _bordTickList.add(Row(
              children: [
                _BordContainer(
                  context: context,
                ),
                _BordContainer(
                  context: context,
                  value: value,
                  valueState: valueState,
                ),
                _BordContainer(
                  context: context,
                ),
              ],
            ));
          }
        }
        //売り板
        for (var i = 0; i < 19; i++) {
          final value = _bordValueList[0] + getTickRange(_bordValueList[0]);
          _bordValueList.insert(0, value);

          int index = _sellList.indexWhere(
              (element) => element.price != null && element.price == value);
          int valueState = 0;
          if (buySymbol != null &&
              buySymbol == bord.symbol &&
              tradingHistoryList
                      .tradingHistoryList[
                          tradingHistoryList.tradingHistoryList.length - 1]
                      .plusTwoPerValue ==
                  value) {
            valueState = 1;
          } else if (value == bord.currentPrice) {
            valueState = 3;
          }

          if (index != -1) {
            _bordTickList.insert(
                0,
                Row(
                  children: [
                    _BordContainer(
                      context: context,
                      value: index != 0
                          ? _sellList[index].qty
                          : '${_sellList[index].qty}',
                      textColor: Colors.blue,
                    ),
                    _BordContainer(
                      context: context,
                      value: value,
                      textColor: index != 0 ? Colors.white : Colors.blue,
                      valueState: valueState,
                    ),
                    _BordContainer(
                      context: context,
                    ),
                  ],
                ));
          } else {
            _bordTickList.insert(
              0,
              Row(
                children: [
                  _BordContainer(
                    context: context,
                  ),
                  _BordContainer(
                    context: context,
                    value: value,
                    valueState: valueState,
                  ),
                  _BordContainer(
                    context: context,
                  ),
                ],
              ),
            );
          }
        }
      }

      return _bordTickList;
    }

    final bordTickList = _calcBordValueList();

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      color: Theme.of(context).background,
      child: Column(
        children: [
          Row(
            children: [
              _BordContainer(
                context: context,
                value: bord.marketOrderSellQty,
                previousValue: priviousBord?.marketOrderSellQty,
              ),
              _BordContainer(context: context, value: '成行'),
              _BordContainer(
                context: context,
                value: bord.marketOrderSellQty,
                previousValue: priviousBord?.marketOrderBuyQty,
              ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              _BordContainer(context: context, value: bord.overSellQty),
              _BordContainer(context: context, value: 'over'),
              _BordContainer(
                context: context,
              ),
            ],
          ),
          SizedBox(
            height: height - 73 < 800 ? height - 73 : 800,
            child: ListView.builder(
              itemCount: bordTickList.length,
              controller: ScrollController(
                  initialScrollOffset: 400 - (height - 73) / 2),
              itemBuilder: (context, index) {
                return bordTickList[index];
              },
            ),
          ),
          Row(
            children: [
              _BordContainer(
                context: context,
              ),
              _BordContainer(context: context, value: 'under'),
              _BordContainer(context: context, value: bord.underBuyQty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _BordContainer({
    var value,
    var previousValue,
    Color textColor = Colors.white,
    int valueState = 0,
    required BuildContext context,
  }) {
    Color boxColor = Theme.of(context).background;
    Color borderColor = Theme.of(context).grayColor;

    switch (valueState) {
      case 1:
        boxColor = Color.fromARGB(255, 163, 99, 2);
        break;
      case 2:
        boxColor = Color.fromARGB(255, 0, 9, 112);
        break;
      case 3:
        boxColor = Colors.white24;
        break;
    }

    if (previousValue != null && previousValue != value) {
      borderColor = Colors.white;
    }

// !containerの値が変化したらアニメーションが走るから、価格ごとの注文数量の変化で動いてない
// todo 色戻るようにしないとみにくい
    return AnimatedContainer(
      width: containerWidth,
      height: containerHeignt,
      alignment: Alignment.center,
      duration: Duration(milliseconds: 30),
      // curve: returnCurve(),
      onEnd: () => boxColor = Theme.of(context).background,
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(
          color: borderColor,
          width: containerBorderWidth,
        ),
      ),
      child: Text(
        '${value ?? ""}',
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
