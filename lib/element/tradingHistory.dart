import 'package:trade_practice_tool/assets/infoUtils.dart';

class TradingHistoryList {
  List<_TradingHistory> tradingHistoryList = [];
  double originAssets = 1000000;
  double sumProfit = 0;
  double sumProfitRate = 0;
  bool buyFlag = false;

  buy(String symbol, String symbolName, String buyTime, double buyValue) {
    if (!buyFlag) {
      buyFlag = true;
      tradingHistoryList.add(_TradingHistory(
        symbol: symbol,
        symbolName: symbolName,
        buyTime: buyTime,
        buyValue: buyValue,
      ));
    }
  }

  String? getBuySymbol() {
    return buyFlag
        ? tradingHistoryList[tradingHistoryList.length - 1].symbol
        : null;
  }

  bool updateValue(double value, String time) {
    if (buyFlag) {
      if (tradingHistoryList[tradingHistoryList.length - 1].plusTwoPerValue <
          value) {
        tradingHistoryList[tradingHistoryList.length - 1].setSell(time,
            tradingHistoryList[tradingHistoryList.length - 1].plusTwoPerValue);
        sumProfit +=
            tradingHistoryList[tradingHistoryList.length - 1].profit.toDouble();
        sumProfitRate = sumProfit / 10000;
        buyFlag = false;
        return true;
      } else if (tradingHistoryList[tradingHistoryList.length - 1]
              .minusThreePerValue >
          value) {
        tradingHistoryList[tradingHistoryList.length - 1].setSell(time, value);
        sumProfit +=
            tradingHistoryList[tradingHistoryList.length - 1].profit.toDouble();
        sumProfitRate = sumProfit / 10000;
        buyFlag = false;
        return true;
      } else {
        tradingHistoryList[tradingHistoryList.length - 1].updateValue(value);
        return false;
      }
    }

    return false;
  }
}

class _TradingHistory {
  _TradingHistory({
    required this.symbol,
    required this.symbolName,
    required this.buyTime,
    required this.buyValue,
  }) {
    final double plusTwoPerValueTickRange = getTickRange(buyValue * 1.02);
    plusTwoPerValue = ((buyValue * 1.02) ~/ plusTwoPerValueTickRange + 1) *
        plusTwoPerValueTickRange;
    final double minusThreePerValueTickRange = getTickRange(buyValue * 0.97);
    minusThreePerValue =
        ((buyValue * 0.97) ~/ minusThreePerValueTickRange + 1) *
            minusThreePerValueTickRange;
    volume =
        buyValue > 10000 ? 100 : ((10000 / buyValue).floor() * 100).toInt();
  }

  final String symbol;
  final String symbolName;
  final String buyTime;
  String? sellTime;
  final double buyValue;
  double? sellValue;
  late int volume;
  late double minusThreePerValue;
  late double plusTwoPerValue;
  int profit = 0;
  double profitRate = 0;
  bool calculating = true;

  updateValue(double value) {
    profit = ((value - buyValue) * volume).toInt();
    profitRate = (((value - buyValue) / buyValue) * 10000).floor() / 100;
  }

  setSell(String sellTime, double sellValue) {
    this.sellTime = sellTime;
    this.sellValue = sellValue;
    profit = ((this.sellValue! - buyValue) * volume).toInt();
    profitRate = (((sellValue - buyValue) / buyValue) * 10000).floor() / 100;
    calculating = false;
  }

  Map<String, dynamic> toMap() {
    if (calculating) {
      return {
        'buyTime': buyTime,
        'sellTime': '',
        'buyValue': buyValue,
        'sellValue': plusTwoPerValue,
        'volume': volume,
        'profit': profit,
        'profitRate': profitRate,
      };
    } else {
      return {
        'buyTime': buyTime,
        'sellTime': sellTime,
        'buyValue': buyValue,
        'sellValue': sellValue,
        'volume': volume,
        'profit': profit,
        'profitRate': profitRate,
      };
    }
  }
}
