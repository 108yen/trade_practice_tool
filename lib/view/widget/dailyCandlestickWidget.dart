import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class DailyCandlestickWidget extends StatelessWidget {
  final DailyCandlestick dailyCandlestick;
  final double width;
  final double height;

  DailyCandlestickWidget({
    required this.dailyCandlestick,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DailyCandlestickPainter(
          dailyCandlestick: dailyCandlestick,
          context: context,
        ),
      ),
    );
  }
}

class _DailyCandlestickPainter extends CustomPainter {
  final DailyCandlestick dailyCandlestick;
  final BuildContext context;
  final double candleWidth;

  _DailyCandlestickPainter({
    required this.dailyCandlestick,
    required this.context,
    this.candleWidth = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double _heightRate =
        size.height / (dailyCandlestick.stopHeight - dailyCandlestick.stopLow);
    final Paint paint = Paint();

    paint.color = Theme.of(context).background;
    canvas.drawRect(Rect.fromLTWH(2, 0, size.width - 4, size.height), paint);

    paint.color = Theme.of(context).grayColor;
    late double baseLineY;
    if (dailyCandlestick.x4 == 0) {
      baseLineY = size.height / 2;
      // 上限4倍
    } else if (dailyCandlestick.x4 == 1) {
      baseLineY = size.height * 0.75;
      // 下限4倍
    } else if (dailyCandlestick == 2) {
      baseLineY = size.height / 4;
    }
    canvas.drawLine(
        Offset(2, baseLineY), Offset(size.width - 2, baseLineY), paint);

    paint.color = dailyCandlestick.dailyOpen > dailyCandlestick.dailyClose
        ? Theme.of(context).primaryGreen
        : Theme.of(context).primaryRed;
    canvas.drawRect(
        Rect.fromLTWH(
          (size.width - candleWidth) / 2,
          (dailyCandlestick.stopHeight -
                  max(dailyCandlestick.dailyClose,
                      dailyCandlestick.dailyOpen)) *
              _heightRate,
          candleWidth,
          (dailyCandlestick.dailyClose - dailyCandlestick.dailyOpen).abs() *
              _heightRate,
        ),
        paint);
    canvas.drawLine(
      Offset(
          size.width / 2,
          (dailyCandlestick.stopHeight - dailyCandlestick.dailyHeight) *
              _heightRate),
      Offset(
          size.width / 2,
          (dailyCandlestick.stopHeight - dailyCandlestick.dailyLow) *
              _heightRate),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
