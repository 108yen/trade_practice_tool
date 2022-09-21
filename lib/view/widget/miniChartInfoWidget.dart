import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class MiniChartInfoWidget extends StatelessWidget {
  final double width;
  final double height;
  final ChartParams miniChartParams;
  final double titleWidth = 160;

  MiniChartInfoWidget({
    required this.width,
    required this.height,
    required this.miniChartParams,
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
              '${miniChartParams.symbol} ${miniChartParams.symbolName}',
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
              '${miniChartParams.currentBord?.currentPrice ?? ''} ${miniChartParams.currentBord?.changePreviousClosePer ?? ''}%',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
