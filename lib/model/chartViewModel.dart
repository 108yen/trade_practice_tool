import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
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
  Isolate? _isolate;
  Capability? _capability;
  int isolateStatus = 0; //0:null,1:play,2:pouse,3:killed
  String presentTime = '';

  static int replaySpeed = 1;

  start() {
    isolateStatus = 1;
    notifyListeners();
    _receiveBordData();
  }

  resume() {
    if (isolateStatus == 1) {
      _capability = _isolate!.pause();
      isolateStatus = 2;
    } else if (isolateStatus == 2) {
      _isolate!.resume(_capability!);
      isolateStatus = 1;
    }
    notifyListeners();
  }

  stop() {
    if (_isolate != null) {
      _isolate!.kill();
      isolateStatus = 3;
    }
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

  exchangeParamListOrder(int oldIndex, int newIndex) {
    final item = miniChartParamsList.removeAt(oldIndex);
    miniChartParamsList.insert(newIndex, item);
    notifyListeners();
    //todo できれば並び変えた状態でobjectboxないのデータも上書きしたい
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
    final firstData = json.decode(sendDatas[0]);
    final firstDateTime = DateTime.parse(firstData['timestamp']);
    Duration delta = Duration(milliseconds: 0);
    final addDelta = Duration(milliseconds: 100);
    final waitDelta = Duration(milliseconds: 100 ~/ replaySpeed);
    int index = 0;

    Map<String, dynamic> jsonPersed = firstData;
    while (index < sendDatas.length - 1) {
      await new Future.delayed(waitDelta);
      delta += addDelta;

      while (index < sendDatas.length - 1 &&
          firstDateTime
              .add(delta)
              .isAfter(DateTime.parse(jsonPersed['timestamp']))) {
        args['sendPort'].send(jsonPersed);
        index += 1;
        jsonPersed = json.decode(sendDatas[index]);
      }
    }
  }

  Future _receiveBordData() async {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    receivePort.listen((message) {
      presentTime = message['timestamp'].substring(11, 19);
      Map<String, dynamic> shaped = {
        'timeStamp': message['timestamp'],
      };
      shaped.addAll(message['message']);
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
    }
  }
}
