import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class TradeHistoryWidget extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double containerHeight = 20;
  final double containerBorderWidth = 0.3;

  TradeHistoryWidget({
    required this.width,
    required this.height,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      color: Theme.of(context).background,
      child: Column(
        children: [
          Container(
            width: width / 2,
            height: containerHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).grayColor,
                width: containerBorderWidth,
              ),
            ),
            child: Text('所持金額とか'),
          ),
        ],
      ),
    );
  }
}
