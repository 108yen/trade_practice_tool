import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/database/raspiDB.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/step.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

class MiniChartsModel extends ChangeNotifier {
  // 全画面で30チャート表示可
  final double miniChartWidth = 319;
  final double miniChartHeight = 208;
  List<ChartParams> miniChartParamsList = [];

  setSampleData() async {
    late ChartParams miniChartParams;
    miniChartParams = ChartParams(
      symbol: '6619',
      symbolName: 'ダブルスコープ',
      date: '2022-09-16',
    );
    await miniChartParams.init();
    miniChartParamsList.add(miniChartParams);

    miniChartParams = ChartParams(
      symbol: '9558',
      symbolName: 'ジャパニアス',
      date: '2022-09-16',
    );
    await miniChartParams.init();
    miniChartParamsList.add(miniChartParams);

    notifyListeners();
  }
}
