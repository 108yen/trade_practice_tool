import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';
import 'package:flutter/material.dart';
import '../models/candle.dart';

class CandleStickWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double candleWidth;
  final double high;
  final double low;
  final double? presentValue;
  final Color bullColor;
  final Color bearColor;

  CandleStickWidget({
    required this.candles,
    required this.index,
    required this.candleWidth,
    required this.low,
    required this.high,
    this.presentValue,
    required this.bearColor,
    required this.bullColor,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CandleStickRenderObject(
      candles,
      index,
      candleWidth,
      low,
      high,
      presentValue,
      bullColor,
      bearColor,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    CandleStickRenderObject candlestickRenderObject =
        renderObject as CandleStickRenderObject;

    if (index <= 0 &&
        candlestickRenderObject._close != null &&
        candlestickRenderObject._close != candles[0].close) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._presentValue = presentValue;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    } else if (candlestickRenderObject._index != index ||
        candlestickRenderObject._candleWidth != candleWidth ||
        candlestickRenderObject._high != high ||
        candlestickRenderObject._low != low ||
        candlestickRenderObject._presentValue != presentValue) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._presentValue = presentValue;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    }
    super.updateRenderObject(context, renderObject);
  }
}

class CandleStickRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _candleWidth;
  late double _low;
  late double _high;
  double? _close;
  late double? _presentValue;
  late Color _bullColor;
  late Color _bearColor;

  CandleStickRenderObject(
    List<Candle> candles,
    int index,
    double candleWidth,
    double low,
    double high,
    double? presentValue,
    Color bullColor,
    Color bearColor,
  ) {
    _candles = candles;
    _index = index;
    _candleWidth = candleWidth;
    _low = low;
    _high = high;
    _presentValue = presentValue;
    _bearColor = bearColor;
    _bullColor = bullColor;
  }

  /// set size as large as possible
  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  /// draws a single candle
  void paintCandle(PaintingContext context, Offset offset, int index,
      Candle candle, double range) {
    Color color = candle.isBull ? _bullColor : _bearColor;

    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double x = size.width + offset.dx - (index + 0.5) * _candleWidth;

    context.canvas.drawLine(
      Offset(x, offset.dy + (_high - candle.high) / range),
      Offset(x, offset.dy + (_high - candle.low) / range),
      paint,
    );

    final double openCandleY = offset.dy + (_high - candle.open) / range;
    final double closeCandleY = offset.dy + (_high - candle.close) / range;

    if ((openCandleY - closeCandleY).abs() > 1) {
      context.canvas.drawLine(
        Offset(x, openCandleY),
        Offset(x, closeCandleY),
        paint..strokeWidth = _candleWidth - 1,
      );
    } else {
      // if the candle body is too small
      final double mid = (closeCandleY + openCandleY) / 2;
      context.canvas.drawLine(
        Offset(x, mid - 0.5),
        Offset(x, mid + 0.5),
        paint..strokeWidth = _candleWidth - 1,
      );
    }
  }

  void paintLatestCandleIndicator(PaintingContext context, Offset offset,
      int index, Candle candle, double range) {
    Paint paint = Paint()..color = Color.fromARGB(255, 132, 142, 156);
    final double x = size.width + offset.dx - (index + 0.5) * _candleWidth;
    final double plusTwoPerValue = candle.close * 1.02;
    final double plusTwoPerY = offset.dy + (_high - plusTwoPerValue) / range;

    context.canvas.drawLine(
      Offset(x, plusTwoPerY),
      Offset(x + _candleWidth, plusTwoPerY),
      paint,
    );

    final span = TextSpan(
      style: TextStyle(
        color: Color.fromARGB(255, 132, 142, 156),
        fontSize: 10,
      ),
      text: '${plusTwoPerValue.toStringAsFixed(1)}',
    );
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        context.canvas, Offset(x + _candleWidth * 1.5, plusTwoPerY - 7));
  }

  void paintPresentValueBar(PaintingContext context, Offset offset,
      double presentValue, double range) {
    Paint paint = Paint()..color = Color.fromARGB(255, 132, 142, 156);
    final double presentValY = offset.dy + (_high - presentValue) / range;

    context.canvas.drawLine(
      Offset(offset.dx, presentValY),
      Offset(offset.dx + size.width, presentValY),
      paint,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double range = (_high - _low) / size.height;
    for (int i = 0; (i + 1) * _candleWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 0) continue;
      var candle = _candles[i + _index];
      paintCandle(context, offset, i, candle, range);
    }
    _close = _candles[0].close;
    if (_index < 0) {
      paintLatestCandleIndicator(context, offset, -_index, _candles[0], range);
    }

    if (_presentValue != null) {
      paintPresentValueBar(
        context,
        offset,
        _presentValue!,
        range,
      );
    }

    context.canvas.save();
    context.canvas.restore();
  }
}
