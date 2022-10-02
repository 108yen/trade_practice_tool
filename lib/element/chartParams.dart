import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:trade_practice_tool/assets/infoUtils.dart';
import 'package:trade_practice_tool/database/raspiDB.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/element/step.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

class ChartParams {
  final String symbol;
  final String symbolName;
  final String date;
  late DateTime baseTime; //5分足で使う

  ChartParams({
    required this.symbol,
    required this.symbolName,
    required this.date,
  }) {
    baseTime = DateTime.parse(date + 'T09:00:00+09:00');
  }

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
        final datetime = DateTime.parse(currentBord!.tradingVolumeTime!)
            .add(Duration(hours: 9));
        final date = DateFormat('yyyy-MM-dd').format(datetime);
        final time = DateFormat('HH:mm:ss').format(datetime);
        final value = currentBord!.currentPrice!;
        final volume =
            (currentBord!.tradingVolume! - previousBord!.tradingVolume!)
                .toDouble();
        // step&candle
        if (volume != 0) {
          final step = Step(date, time, value, volume);
          if (steps.isEmpty) {
            step.isBuy = true;
          } else if (steps[steps.length - 1].value > value) {
            step.isBuy = false;
          } else if (steps[steps.length - 1].value < value) {
            step.isBuy = true;
          } else {
            step.isBuy = steps[steps.length - 1].isBuy;
          }
          steps.add(step);

          _updateCandles(value, volume, currentBord!.vwap!, datetime);
        }
        // dailychart
        if (!dailyCandlestick.alreadySetPreviousDayClose() &&
            currentBord?.previousClose != null) {
          dailyCandlestick.setPreviousDayClose(currentBord!.previousClose!);
        } else if (!dailyCandlestick.alreadySetPreviousDayClose() &&
            currentBord?.currentPrice != null) {
          dailyCandlestick.setPreviousDayClose(currentBord!.currentPrice!);
        }
        if (!dailyCandlestick.alreadySetOpen() &&
            currentBord?.openingPrice != null) {
          dailyCandlestick.setOpenValue(currentBord!.openingPrice!);
        } else if (currentBord?.currentPrice != null) {
          dailyCandlestick.updateValue(currentBord!.currentPrice!);
        }
      }
    }
  }

  bool _isBizday(String date) {
    DateTime today = DateTime.parse(date + ' 09:00:00');
    return !(today.weekday == DateTime.sunday ||
        today.weekday == DateTime.saturday ||
        holiday.containsKey(date));
  }

  String _searchPreviousDay(String _date) {
    DateTime baseDate = DateTime.parse(_date + ' 09:00:00');
    String previousDay;
    int i = 0;
    do {
      i += 1;
      previousDay =
          DateFormat('yyyy-MM-dd').format(baseDate.subtract(Duration(days: i)));
    } while (!_isBizday(previousDay));

    return previousDay;
  }

  FiveminTickBox? _getFiveminTickBoxData(String symbol, String date) {
    final fiveminTickBox = store.box<FiveminTickBox>();
    final query = fiveminTickBox
        .query(FiveminTickBox_.symbol
            .equals(symbol)
            .and(FiveminTickBox_.date.equals(date)))
        .build();
    final fetched = query.findFirst();

    return fetched;
  }

  _storeFiveminTickBoxData(String symbol, String date,
      List<Candle> fiveminTickList, List<double> vwap) {
    final fiveminTickBox = store.box<FiveminTickBox>();
    fiveminTickBox.put(FiveminTickBox.toString(
      symbol: symbol,
      date: date,
      fiveminTickList: fiveminTickList,
      vwap: vwap,
    ));
  }

  Future setPreviousDayData() async {
    String previousDay = _searchPreviousDay(date);

    final FiveminTickBox? previousdayFiveminTickBox =
        _getFiveminTickBoxData(symbol, previousDay);
    if (previousdayFiveminTickBox != null) {
      candles = previousdayFiveminTickBox.getCandles();
      vwapIndicator.values = previousdayFiveminTickBox.getVwap();
      dailyCandlestick = DailyCandlestick(candles[0].close);
      // raspiにデータがあった時の処理
    } else if (await RaspiDB.getDataExist(int.parse(symbol), previousDay)) {
      final Map<String, dynamic> result = await _stepToCandles(
        steps: await RaspiDB.getStep(
          previousDay,
          int.parse(symbol),
        ),
      );
      candles = result['candles'];
      vwapIndicator.values = result['vwapData'];
      _storeFiveminTickBoxData(
          symbol, previousDay, result['candles'], result['vwapData']);
      dailyCandlestick = DailyCandlestick(candles[0].close);
    } else {
      dailyCandlestick = DailyCandlestick(0);
    }

    // 前々日のデータもあれば設定
    String twoDaysBefore = _searchPreviousDay(previousDay);

    final FiveminTickBox? twoDaysBeforeFiveminTickBox =
        _getFiveminTickBoxData(symbol, twoDaysBefore);
    if (twoDaysBeforeFiveminTickBox != null) {
      candles.addAll(twoDaysBeforeFiveminTickBox.getCandles());
      vwapIndicator.values.addAll(twoDaysBeforeFiveminTickBox.getVwap());
    }
  }

  Future<Map<String, dynamic>> _stepToCandles({
    required List<Step> steps,
  }) async {
    List<dynamic> _fiveMinData = [];
    List<double> _vwapData = [];
    DateTime _baseTime = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(steps[0].datetime) + ' 09:00:00');

    double max = 0;
    double min = 99999;
    double first = steps[0].value;
    double fin = 0;
    double volume = 0;
    double _sumTradingValue = 0;
    double _sumVolume = 0;

    while (!_baseTime.isAfter(steps[0].datetime)) {
      _baseTime = _baseTime.add(Duration(minutes: 5));
    }

    for (var data in steps) {
      DateTime datetime = data.datetime;
      double s_value = data.value;
      double s_volume = data.volume;

      _sumTradingValue += s_value * s_volume;
      _sumVolume += s_volume;

      if (!_baseTime.isAfter(datetime)) {
        _fiveMinData.add([
          _baseTime.subtract(Duration(minutes: 5)),
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

        _baseTime = _baseTime.add(Duration(minutes: 5));
        if (_baseTime.hour == 11 && _baseTime.minute == 40) {
          _baseTime = _baseTime.add(Duration(minutes: 55));
        } else {
          while (!_baseTime.isAfter(datetime)) {
            _fiveMinData.add([
              _baseTime.subtract(Duration(minutes: 5)),
              s_value,
              s_value,
              s_value,
              s_value,
              0.0
            ]);
            _vwapData.add(_sumTradingValue / _sumVolume);
            if (_baseTime.hour == 11 && _baseTime.minute == 35) {
              _baseTime = _baseTime.add(Duration(hours: 1));
            } else {
              _baseTime = _baseTime.add(Duration(minutes: 5));
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
    _fiveMinData.add([
      _baseTime.subtract(Duration(minutes: 5)),
      s_value,
      s_value,
      s_value,
      s_value,
      s_volume
    ]);
    _vwapData.add(_sumTradingValue / _sumVolume);

    final List<Candle> _candles = _fiveMinData
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

  _updateCandles(double value, double volume, double vwap, DateTime datetime) {
    // 1本目の処理
    if (candles.isEmpty ||
        candles[0].date.isBefore(DateTime.parse(date + ' 09:00:00'))) {
      // 最初の足は寄りまで飛ばす
      while (!baseTime.isAfter(datetime)) {
        baseTime = baseTime.add(Duration(minutes: 5));
      }
      candles.insert(
        0,
        Candle(
          date: baseTime.subtract(Duration(minutes: 5)),
          high: value,
          low: value,
          open: value,
          close: value,
          volume: volume,
        ),
      );
      vwapIndicator.values.insert(0, vwap);
      // 5分刻み超えた時の処理（ローソク足追加＋初期化）
    } else if (!baseTime.isAfter(datetime)) {
      candles.insert(
        0,
        Candle(
          date: baseTime,
          high: value,
          low: value,
          open: value,
          close: value,
          volume: volume,
        ),
      );
      vwapIndicator.values.insert(0, vwap);
      baseTime = baseTime.add(Duration(minutes: 5));
      // 時間飛んでる時の処理（足は5分ごとに追加する）
      while (!baseTime.isAfter(datetime)) {
        if ((baseTime.hour < 11 && baseTime.minute < 40) ||
            (baseTime.hour > 12 && baseTime.minute > 30)) {
          candles.insert(
            0,
            Candle(
              date: baseTime,
              high: value,
              low: value,
              open: value,
              close: value,
              volume: 0.0,
            ),
          );
          vwapIndicator.values.insert(0, vwap);
        }
        baseTime = baseTime.add(Duration(minutes: 5));
      }
      // 五分刻み内の処理
    } else {
      candles[0] = Candle(
        date: candles[0].date,
        high: candles[0].high > value ? candles[0].high : value,
        low: candles[0].low < value ? candles[0].low : value,
        open: candles[0].open,
        close: value,
        volume: candles[0].volume + volume,
      );
      vwapIndicator.values[0] = vwap;
    }

    tickIndicator.values.insert(0, value);
  }
}
