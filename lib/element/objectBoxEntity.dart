import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

@Entity()
class BordBox {
  int id;

  int code;
  String date;
  List<String> bordList;

  BordBox({
    this.id = 0,
    required this.code,
    required this.date,
    required this.bordList,
  });
}

@Entity()
class FiveminTickBox {
  int id;

  String symbol;
  String date;
  late List<String> fiveminTickList;
  late List<String> vwap;

  FiveminTickBox({
    this.id = 0,
    required this.symbol,
    required this.date,
    required this.fiveminTickList,
    required this.vwap,
  });

  FiveminTickBox.toString({
    this.id = 0,
    required this.symbol,
    required this.date,
    required List<Candle> fiveminTickList,
    required List<double> vwap,
  }) {
    this.fiveminTickList =
        fiveminTickList.map((e) => json.encode(e.toJson())).toList();
    this.vwap = vwap.map((e) => e.toString()).toList();
  }

  List<Candle> getCandles() =>
      this.fiveminTickList.map((e) => Candle.fromJson(json.decode(e))).toList();
  List<double> getVwap() => this.vwap.map((e) => double.parse(e)).toList();
}

@Entity()
class SymbolInfoListBox {
  int id;

  DateTime timestamp;
  List<String> symbolInfoList;

  SymbolInfoListBox({
    this.id = 0,
    required this.timestamp,
    required this.symbolInfoList,
  });
}

@Entity()
class MessageTestBox {
  @Id(assignable: true)
  int id;

  List<String> messageList;

  MessageTestBox({
    this.id = 0,
    required this.messageList,
  });
}
