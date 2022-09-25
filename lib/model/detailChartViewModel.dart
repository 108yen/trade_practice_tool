import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/element/step.dart' as kabuStep;
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/utils/candlesticks/candlesticks.dart';

import '../main.dart';

class DetailChartViewModel extends ChangeNotifier {
  final String symbol;
  late ChartParams chartParams;
  TradingHistoryList tradingHistoryList = TradingHistoryList();

  DetailChartViewModel({
    required this.symbol,
  }) {
    chartParams = ChartParams(
      symbol: symbol,
      symbolName: 'ANYCOLOR',
      date: '2022-09-21',
    );
  }

  String receiveMessage = '';
  String presentTime = '';
  int listLength = 0;
  int nowLength = 0;

  static Future sendBordData(Map<String, dynamic> args) async {
    final List<String> sendDatas = args['data'];
    for (var item in sendDatas) {
      await new Future.delayed(Duration(milliseconds: 1));
      args['sendPort'].send(item);
    }
  }

  // DailyCandlestick dailyCandlestick = DailyCandlestick(0);

  Future init() async {
    await chartParams.init();
    notifyListeners();
  }

  Future receiveBordData() async {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    receivePort.listen((message) {
      nowLength += 1;
      final jsonPersed = json.decode(message);
      Map<String, dynamic> shaped = {
        'timeStamp': jsonPersed['timestamp'],
      };
      shaped.addAll(jsonPersed['message']);
      final Bord receivedBord = Bord.fromJson(shaped);
      // if (receivedBord.timeStamp != null) {
      //   presentTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
      //       .format(receivedBord.timeStamp!);
      // }
      if (receivedBord.buy1.time != null) {
        presentTime = receivedBord.buy1.time!;
      }

      if (receivedBord.symbol! == chartParams.symbol) {
        chartParams.setBord(receivedBord);
      }
      notifyListeners();
    });

    final messageTestBox = store.box<MessageTestBox>();
    Query query = messageTestBox.query(MessageTestBox_.id.equals(6)).build();
    final fetchData = query.findFirst();

    if (fetchData != null) {
      listLength = fetchData.messageList.length;
      await Isolate.spawn(sendBordData, {
        'sendPort': sendPort,
        'data': fetchData.messageList,
      });
    }
  }
}
