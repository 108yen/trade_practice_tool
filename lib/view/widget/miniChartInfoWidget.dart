import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class MiniChartInfoWidget extends StatelessWidget {
  final double width;
  final double height;
  final Bord? bord;

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
      decoration: BoxDecoration(
        color: Theme.of(context).background,
        border: Border.all(
          color: Theme.of(context).grayColor,
        ),
      ),
      child: Text('${bord?.symbol ?? 'no data'} ${bord?.symbolName ?? ''}'),
    );
  }
}
