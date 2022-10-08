import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/element/symbol.dart';

class ChartViewModel extends ChangeNotifier {
  final String replayDate;

  ChartViewModel({
    required this.replayDate,
  });

  List<ChartParams> miniChartParamsList = [];
  int? detailChartIndex;
  TradingHistoryList tradingHistoryList = TradingHistoryList();
  bool isPopup = false;
  late Isolate _isolate;
  late Capability _capability;
  int isolateStatus = 0; //0:null,1:play,2:pouse,3:killed

  start() {
    _receiveBordData();
  }

  resume() {
    if (isolateStatus == 1) {
      _capability = _isolate.pause();
      isolateStatus = 2;
    } else if (isolateStatus == 2) {
      _isolate.resume(_capability);
      isolateStatus = 1;
    }
  }

  stop() {
    _isolate.kill();
    isolateStatus = 3;
  }

  changeIsPopup() {
    isPopup = !isPopup;
    notifyListeners();
  }

  buy() {
    if (detailChartIndex != null &&
        miniChartParamsList[detailChartIndex!].currentBord?.sell1.time !=
            null &&
        miniChartParamsList[detailChartIndex!].currentBord?.sell1.price !=
            null) {
      tradingHistoryList.buy(
        miniChartParamsList[detailChartIndex!].symbol,
        miniChartParamsList[detailChartIndex!].symbolName,
        miniChartParamsList[detailChartIndex!].currentBord!.sell1.time!,
        miniChartParamsList[detailChartIndex!].currentBord!.sell1.price!,
      );
    }
  }

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

      final buySymbol = tradingHistoryList.getBuySymbol();
      if (buySymbol != null &&
          receivedBord.symbol == buySymbol &&
          receivedBord.currentPrice != null &&
          receivedBord.currentPriceTime != null) {
        tradingHistoryList.updateValue(
          receivedBord.currentPrice!,
          receivedBord.currentPriceTime!,
        );
      }

      notifyListeners();
    });

    final messageBox = store.box<MessageBox>();
    Query query = messageBox.query(MessageBox_.date.equals(replayDate)).build();
    final fetchData = query.findFirst();

    if (fetchData != null) {
      _isolate = await Isolate.spawn(sendBordData, {
        'sendPort': sendPort,
        'data': fetchData.messageList,
      });
      isolateStatus = 1;
    }
  }
}
