import 'package:trade_practice_tool/assets/infoUtils.dart';

class TradingHistoryList {
  List<_TradingHistory> tradingHistoryList = [];
  double sumProfit = 0;
  double sumProfitRate = 0;
  bool buyFlag = false;

  buy(String symbol, String buyTime, double buyValue) {
    if (!buyFlag) {
      buyFlag = true;
      tradingHistoryList.add(_TradingHistory(
          symbol: symbol, buyTime: buyTime, buyValue: buyValue));
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
        buyFlag = false;
        return true;
      } else if (tradingHistoryList[tradingHistoryList.length - 1]
              .minusThreePerValue >
          value) {
        tradingHistoryList[tradingHistoryList.length - 1].setSell(time, value);
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
    required this.buyTime,
    required this.buyValue,
  }) {
    final double plusTwoPerValueTickRange = getTickRange(buyValue * 1.02);
    plusTwoPerValue = ((buyValue * 1.02) ~/ plusTwoPerValueTickRange + 1) *
        plusTwoPerValueTickRange;
    final double minusThreePerValueTickRange = getTickRange(buyValue * 0.97);
    minusThreePerValue =
        ((buyValue * 1.02) ~/ minusThreePerValueTickRange + 1) *
            minusThreePerValueTickRange;
    volume =
        buyValue > 10000 ? 100 : ((10000 / buyValue).floor() * 100).toInt();
  }

  final String symbol;
  final String buyTime;
  late String sellTime;
  final double buyValue;
  late double sellValue;
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
    profit = ((this.sellValue - buyValue) * volume).toInt();
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
