import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/step.dart' as KabuStep;
import 'package:trade_practice_tool/theme/theme_data.dart';

class TickVolumeWidget extends StatelessWidget {
  const TickVolumeWidget({
    Key? key,
    required this.steps,
    required this.widgetWidth,
    required this.widgetHeight,
  }) : super(key: key);

  final List<KabuStep.Step> steps;
  final double widgetWidth;
  final double widgetHeight;
  final double _stickWidth = 3;

  @override
  Widget build(BuildContext context) {
    final int displayableNum = ((widgetWidth - 60) / _stickWidth).floor() + 1;
    final List<KabuStep.Step> displayStepList = steps.length <= displayableNum
        ? steps
        : steps.sublist(steps.length - displayableNum).toList();
    int _maxTradingValue = 0;
    double _maxValue = 0;
    double _minValue = 999999;

    for (KabuStep.Step item in displayStepList) {
      _maxTradingValue = max(_maxTradingValue, item.tradingValue);
      _maxValue = max(_maxValue, item.value);
      _minValue = min(_minValue, item.value);
    }

    String displayValue = '${NumberFormat("#,###").format(_maxTradingValue)}';
    if (displayValue.length > 5) {
      displayValue = '${displayValue.substring(0, displayValue.length - 5)}万';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1),
      child: Row(
        children: [
          SizedBox(
            height: widgetHeight - 2,
            width: widgetWidth - 60,
            child: CustomPaint(
              painter: _TickVolumePainter(
                steps,
                context,
                _maxTradingValue,
                _stickWidth,
                _maxValue,
                _minValue,
              ),
            ),
          ),
          SizedBox(
            height: widgetHeight - 2,
            width: 60,
            child: Container(
              color: Theme.of(context).background,
              child: Row(
                children: [
                  Container(
                    width: 1,
                    height: widgetHeight - 2,
                    color: Theme.of(context).grayColor,
                  ),
                  SizedBox(
                    height: widgetHeight - 2,
                    width: 59,
                    child: Column(
                      children: [
                        Text(
                          displayValue,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).scaleNumbersColor,
                            fontSize: 11,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '-${displayValue}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).scaleNumbersColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TickVolumePainter extends CustomPainter {
  _TickVolumePainter(this._steps, this._context, this._maxTradingValue,
      this._stickWidth, this._maxValue, this._minValue);

  final List<KabuStep.Step> _steps;
  final BuildContext _context;
  final int _maxTradingValue;
  final double _stickWidth;
  final double _maxValue;
  final double _minValue;
  final _stickPadding = 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Theme.of(_context).background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    paint.color = Theme.of(_context).grayColor;

    paint.strokeWidth = 1;
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    paint.strokeWidth = 0.5;
    canvas.drawLine(
        Offset(0, size.height / 4), Offset(size.width, size.height / 4), paint);
    canvas.drawLine(Offset(0, size.height * 3 / 4),
        Offset(size.width, size.height * 3 / 4), paint);

    if (_steps.isEmpty) {
      return;
    }

    final double _TDHeightRate = (size.height / 2) / _maxTradingValue;
    final double _ValueHeightRate = size.height / (_maxValue - _minValue);

    Path? path;
    for (int i = 0;
        size.width > _stickWidth * i && _steps.length >= (i + 1);
        i++) {
      int index = _steps.length - (i + 1);
      double top = _steps[index].isBuy!
          ? size.height / 2 - _steps[index].tradingValue * _TDHeightRate
          : size.height / 2;
      double left = size.width - _stickWidth * (i + 1) + _stickPadding;
      double width = _stickWidth - _stickPadding * 2;
      double height = _steps[index].tradingValue * _TDHeightRate;

      paint.color = _steps[index].isBuy!
          ? Theme.of(_context).primaryRed
          : Theme.of(_context).primaryGreen;
      paint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(left, top, width, height), paint);

      if (path == null) {
        path = Path()
          ..moveTo(
            size.width - _stickWidth / 2,
            (_maxValue - _steps[index].value) * _ValueHeightRate,
          );
      } else {
        path.lineTo(
          size.width - _stickWidth * (i + 0.5),
          (_maxValue - _steps[index].value) * _ValueHeightRate,
        );
      }
    }
    if (path != null) {
      paint.color = Theme.of(_context).grayColor;
      paint.strokeWidth = 0.5;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
