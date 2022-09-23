import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/element/symbol.dart';

class ChartViewModel extends ChangeNotifier {
  final String replayDate = '2022-09-21';
  List<ChartParams> miniChartParamsList = [];
  int? detailChartIndex;

  setDetailChartIndex(String symbol) {
    detailChartIndex = miniChartParamsList.indexWhere(
      (element) => element.symbol == symbol,
    );
    notifyListeners();
  }

  setDetailChartIndexNull() {
    detailChartIndex = null;
    notifyListeners();
  }

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
      _receiveBordData();
    }
  }

  static Future sendBordData(Map<String, dynamic> args) async {
    final List<String> sendDatas = args['data'];
    for (var item in sendDatas) {
      await new Future.delayed(Duration(milliseconds: 1));
      args['sendPort'].send(item);
    }
  }

  Future _receiveBordData() async {
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