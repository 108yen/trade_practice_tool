import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:trade_practice_tool/assets/holidayList.dart';
import 'package:trade_practice_tool/database/raspiDB.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/step.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

class MiniChartParams {
  final String symbol;
  final String symbolName;
  final String date;

  MiniChartParams({
    required this.symbol,
    required this.symbolName,
    required this.date,
  });

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
  Bord? currentBord;
  Bord? previousBord;
  List<Step> steps = [];

  Future init() async {
    await setPreviousDayData();
  }

  setBord(Bord bord) {
    previousBord = currentBord;
    currentBord = bord;
    if (previousBord?.tradingVolume != null) {
      if (currentBord?.tradingVolume != null &&
          currentBord?.tradingVolumeTime != null &&
          currentBord?.currentPrice != null) {
        final datetime = DateTime.parse(currentBord!.tradingVolumeTime!);
        final date = DateFormat('yyyy-MM-dd').format(datetime);
        final time = DateFormat('HH:mm:ss').format(datetime);
        final value = currentBord!.currentPrice!;
        final volume =
            (currentBord!.tradingVolume! - previousBord!.tradingVolume!)
                .toDouble();
        steps.add(Step(date, time, value, volume));
      }
    }
  }

  bool _isBizday(String date) {
    DateTime today = DateTime.parse(date + ' 09:00:00');
    return !(today.weekday == DateTime.sunday ||
        today.weekday == DateTime.saturday ||
        holiday.containsKey(date));
  }

  String _searchPreviousDay() {
    DateTime baseDate = DateTime.parse(date + ' 09:00:00');
    String previousDay;
    int i = 0;
    do {
      i += 1;
      previousDay =
          DateFormat('yyyy-MM-dd').format(baseDate.subtract(Duration(days: i)));
    } while (!_isBizday(previousDay));

    return previousDay;
  }

  Future setPreviousDayData() async {
    String previousDay = _searchPreviousDay();

    // もし前日のデータ持ってなかったらraspiから持ってくる
    final Map<String, dynamic> result = await _stepToCandles(
      steps: await RaspiDB.getStep(
        previousDay,
        int.parse(symbol),
      ),
    );
    candles = result['candles'];
    vwapIndicator.values = result['vwapData'];
    dailyCandlestick = DailyCandlestick(candles[0].close);
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