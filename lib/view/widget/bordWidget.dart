import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class BordWidget extends StatelessWidget {
  final Bord bord;
  final Bord? priviousBord;
  final double width = 250;
  final double height = 473;
  final double containerWidth = 80;
  final double containerHeignt = 20;
  final double containerBorderWidth = 0.3;

  BordWidget({
    required this.bord,
    required this.priviousBord,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> priceList = [
      _BordContainer(
        context: context,
        value: bord.sell10.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell9.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell8.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell7.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell6.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell5.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell4.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell3.price,
      ),
      _BordContainer(
        context: context,
        value: bord.sell2.price,
      ),
      _BordContainer(
          context: context, value: bord.sell1.price, textColor: Colors.blue),
      _BordContainer(
          context: context, value: bord.buy1.price, textColor: Colors.red),
      _BordContainer(context: context, value: bord.buy2.price),
      _BordContainer(context: context, value: bord.buy3.price),
      _BordContainer(context: context, value: bord.buy4.price),
      _BordContainer(context: context, value: bord.buy5.price),
      _BordContainer(context: context, value: bord.buy6.price),
      _BordContainer(context: context, value: bord.buy7.price),
      _BordContainer(context: context, value: bord.buy8.price),
      _BordContainer(context: context, value: bord.buy9.price),
      _BordContainer(context: context, value: bord.buy10.price),
    ];
    List<Widget> buyList = [
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
        value: bord.buy1.qty,
        previousValue: priviousBord?.buy1.qty,
        textColor: Colors.red,
      ),
      _BordContainer(
        context: context,
        value: bord.buy2.qty,
        previousValue: priviousBord?.buy2.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy3.qty,
        previousValue: priviousBord?.buy3.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy4.qty,
        previousValue: priviousBord?.buy4.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy5.qty,
        previousValue: priviousBord?.buy5.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy6.qty,
        previousValue: priviousBord?.buy6.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy7.qty,
        previousValue: priviousBord?.buy7.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy8.qty,
        previousValue: priviousBord?.buy8.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy9.qty,
        previousValue: priviousBord?.buy9.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy10.qty,
        previousValue: priviousBord?.buy10.qty,
      ),
    ];
    List<Widget> sellList = [
      _BordContainer(
        context: context,
        value: bord.buy10.qty,
        previousValue: priviousBord?.buy10.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy9.qty,
        previousValue: priviousBord?.buy9.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy8.qty,
        previousValue: priviousBord?.buy8.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy7.qty,
        previousValue: priviousBord?.buy7.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy6.qty,
        previousValue: priviousBord?.buy6.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy5.qty,
        previousValue: priviousBord?.buy5.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy4.qty,
        previousValue: priviousBord?.buy4.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy3.qty,
        previousValue: priviousBord?.buy3.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy2.qty,
        previousValue: priviousBord?.buy2.qty,
      ),
      _BordContainer(
        context: context,
        value: bord.buy1.qty,
        previousValue: priviousBord?.buy1.qty,
        textColor: Colors.blue,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
      _BordContainer(
        context: context,
      ),
    ];

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
                value: bord.marketOrderBuyQty,
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
          Row(
            children: [
              Column(
                children: sellList,
              ),
              Column(
                children: priceList,
              ),
              Column(
                children: buyList,
              ),
            ],
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
    required BuildContext context,
  }) {
    Color boxColor = Theme.of(context).background;
    Color borderColor = Theme.of(context).grayColor;
    if (previousValue != null && previousValue != value) {
      // boxColor = Colors.white12;
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

// class returnCurve extends Curve {
//   @override
//   double transform(double t) {
//     print(sin(pi * t));
//     return t;
//   }
// }
