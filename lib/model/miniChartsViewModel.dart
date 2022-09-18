import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/database/raspiDB.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/step.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

class MiniChartsModel extends ChangeNotifier {
  final double width = 400;
  final double height = 200;
  List<Candle> candles = [];
  IndicatorComponentData vwapIndicator = IndicatorComponentData(
    'vwap',
    Color.fromARGB(255, 255, 140, 0),
  );
  IndicatorComponentData tickIndicator = IndicatorComponentData(
    'tick',
    Color.fromARGB(255, 132, 142, 156),
  );
  DailyCandlestick dailyCandlestick = DailyCandlestick(0);
  Bord? bord;

  setSampleData() async {
    final Map<String, dynamic> result = await _stepToCandles(
      steps: await RaspiDB.getStep(
        '2022-04-15',
        5029,
      ),
    );
    candles = result['candles'];
    vwapIndicator.values = result['vwapData'];
    dailyCandlestick = DailyCandlestick(candles[0].close);

    notifyListeners();
  }

  Future<Map<String, dynamic>> _stepToCandles({
    required List<Step> steps,
  }) async {
    List<dynamic> fiveMinData = [];
    List<double> _vwapData = [];
    DateTime baseTime = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(steps[0].datetime) + ' 09:00:00');

    double max = 0;
    double min = 99999;
    double first = steps[0].value;
    double fin = 0;
    double volume = 0;
    double _sumTradingValue = 0;
    double _sumVolume = 0;

    while (!baseTime.isAfter(steps[0].datetime)) {
      baseTime = baseTime.add(Duration(minutes: 5));
    }

    for (var data in steps) {
      DateTime datetime = data.datetime;
      double s_value = data.value;
      double s_volume = data.volume;

      _sumTradingValue += s_value * s_volume;
      _sumVolume += s_volume;

      if (!baseTime.isAfter(datetime)) {
        fiveMinData.add([
          baseTime.subtract(Duration(minutes: 5)),
          first,
          max,
          min,
          fin,
          volume
        ]);
        first = s_value;
        max = s_value;
        min = s_value;
        volume = s_value;
        _vwapData.add(_sumTradingValue / _sumVolume);

        baseTime = baseTime.add(Duration(minutes: 5));
        if (baseTime.hour == 11 && baseTime.minute == 40) {
          baseTime = baseTime.add(Duration(minutes: 55));
        } else {
          while (!baseTime.isAfter(datetime)) {
            fiveMinData.add([
              baseTime.subtract(Duration(minutes: 5)),
              s_value,
              s_value,
              s_value,
              s_value,
              0.0
            ]);
            _vwapData.add(_sumTradingValue / _sumVolume);
            if (baseTime.hour == 11 && baseTime.minute == 35) {
              baseTime = baseTime.add(Duration(hours: 1));
            } else {
              baseTime = baseTime.add(Duration(minutes: 5));
            }
          }
        }
      }

      if (s_value > max) {
        max = s_value;
      }
      if (s_value < min) {
        min = s_value;
      }
      volume += s_volume;
      fin = s_value;
    }
    double s_value = steps[steps.length - 1].value;
    double s_volume = steps[steps.length - 1].volume;
    fiveMinData.add([
      baseTime.subtract(Duration(minutes: 5)),
      s_value,
      s_value,
      s_value,
      s_value,
      s_volume
    ]);
    _vwapData.add(_sumTradingValue / _sumVolume);

    final List<Candle> _candles = fiveMinData
        .map((e) => Candle(
            date: e[0],
            open: e[1],
            high: e[2],
            low: e[3],
            close: e[4],
            volume: e[5]))
        .toList()
        .reversed
        .toList();

    return {
      'candles': _candles,
      'vwapData': _vwapData.reversed.toList(),
    };
  }
}
