import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class TradeHistoryWidget extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double containerHeight = 20;
  final double containerBorderWidth = 0.3;
  final double padding = 5.0;

  TradeHistoryWidget({
    required this.width,
    required this.height,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget _infoColumn(String index, String info) {
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
            ),
          ),
        ],
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      color: Theme.of(context).background,
      child: Column(
        children: [
          _infoColumn('所持金額合計', '1,000,000 円'),
          _infoColumn('利益', '40,000 円'),
          _infoColumn('利益率', '4 %'),
          _infoColumn('仮利益', '4,000 円'),
          OutlinedButton(
            onPressed: () {},
            child: Text('成買'),
          ),
        ],
      ),
    );
  }
}
