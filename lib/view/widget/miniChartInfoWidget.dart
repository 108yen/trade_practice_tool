import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class MiniChartInfoWidget extends StatelessWidget {
  final double width;
  final double height;
  final Bord? bord;
  final double titleWidth = 250;

  MiniChartInfoWidget({
    required this.width,
    required this.height,
    required this.bord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).background,
      child: Row(
        children: [
          Container(
            width: titleWidth,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).grayColor,
              ),
            ),
            child: Text(
              '${bord?.symbol ?? 'no data'} ${bord?.symbolName ?? ''}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: width - titleWidth,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).grayColor,
              ),
            ),
            child: Text(
              '${bord?.currentPrice ?? ''} ${bord?.changePreviousClosePer ?? ''}%',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
