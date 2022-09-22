import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/database/raspiDB.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/element/step.dart';
import 'package:trade_practice_tool/element/symbol.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/utils/candlesticks/src/models/candle.dart';

import '../main.dart';

class MiniChartsModel extends ChangeNotifier {
  // 全画面で30チャート表示可
  final double miniChartWidth = 319;
  final double miniChartHeight = 208;
  final String replayDate = '2022-09-21';
  List<ChartParams> miniChartParamsList = [];

  setSampleData() async {
    final box = store.box<SymbolInfoListBox>();
    final searchDatetime = DateTime.parse(replayDate);
    final query = box
        .query(SymbolInfoListBox_.timestamp.between(
          searchDatetime.millisecondsSinceEpoch,
          searchDatetime.add(Duration(days: 1)).millisecondsSinceEpoch,
        ))
        .build();
    final symbolInfoListBoxList = query.find();
    query.close();
    if (symbolInfoListBoxList != null) {
      final symbolList = symbolInfoListBoxList[symbolInfoListBoxList.length - 1]
          .symbolInfoList
          .map((e) => Symbol.fromJson(json.decode(e)))
          .toList();
      late ChartParams miniChartParams;
      for (var item in symbolList) {
        miniChartParams = ChartParams(
          symbol: item.symbol,
          symbolName: item.symbolName,
          date: replayDate,
        );
        await miniChartParams.init();
        miniChartParamsList.add(miniChartParams);
        notifyListeners();
      }
      receiveBordData();
    }
  }

  static Future sendBordData(Map<String, dynamic> args) async {
    final List<String> sendDatas = args['data'];
    for (var item in sendDatas) {
      await new Future.delayed(Duration(milliseconds: 1));
      args['sendPort'].send(item);
    }
  }

  Future receiveBordData() async {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    receivePort.listen((message) {
      final jsonPersed = json.decode(message);
      Map<String, dynamic> shaped = {
        'timeStamp': jsonPersed['timestamp'],
      };
      shaped.addAll(jsonPersed['message']);
      final Bord receivedBord = Bord.fromJson(shaped);
      
      miniChartParamsList
          .firstWhere(
            (element) => element.symbol == receivedBord.symbol!,
          )
          .setBord(receivedBord);
      
      notifyListeners();
    });

    final messageBox = store.box<MessageBox>();
    Query query = messageBox.query(MessageBox_.date.equals(replayDate)).build();
    final fetchData = query.findFirst();

    if (fetchData != null) {
      await Isolate.spawn(sendBordData, {
        'sendPort': sendPort,
        'data': fetchData.messageList,
      });
    }
  }
}
