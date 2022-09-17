import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/dailyCandlestick.dart';
import 'package:trade_practice_tool/element/indicatorComponentData.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/element/step.dart' as kabuStep;
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/utils/candlesticks/candlesticks.dart';

import '../main.dart';

class DetailChartViewModel extends ChangeNotifier {
  String receiveMessage = '';
  Bord? displayBord;
  Bord? previousBord;
  String presentTime = '';
  int listLength = 0;
  int nowLength = 0;
  List<Candle> candles = [];
  IndicatorComponentData vwapIndicator = IndicatorComponentData(
    'vwap',
    Color.fromARGB(255, 255, 140, 0),
  );
  IndicatorComponentData tickIndicator = IndicatorComponentData(
    'tick',
    Color.fromARGB(255, 132, 142, 156),
  );
  List<kabuStep.Step> receiveSteps = [];

  static Future sendBordData(Map<String, dynamic> args) async {
    final List<String> sendDatas = args['data'];
    for (var item in sendDatas) {
      await new Future.delayed(Duration(milliseconds: 1));
      args['sendPort'].send(item);
    }
  }

  DailyCandlestick dailyCandlestick = DailyCandlestick(0);

  testPrint() {
    final messageTestBox = store.box<MessageTestBox>();
    final query = messageTestBox.query(MessageTestBox_.id.equals(4)).build();
    final fetchData = query.findFirst();
    if (fetchData != null && fetchData.messageList.isNotEmpty) {
      receiveMessage = _fixdata(fetchData.messageList[0]);
    }
    notifyListeners();
  }

  String _fixdata(String data) {
    final splited = data.split('"');
    final String timestampSplited = splited[2].split(',')[0];

    return '{"${splited[1].substring(0, 9)}":"${timestampSplited}","${splited[3].substring(0, 7)}":${data.substring(timestampSplited.length == 23 ? 47 : 50)}';
  }

  Future receiveBordData() async {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    receivePort.listen((message) {
      nowLength += 1;
      final jsonPersed = json.decode(_fixdata(message));
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

      if (receivedBord.symbol! == '4934') {
        previousBord = displayBord;
        displayBord = receivedBord;

        _storageReceiveStep(previousBord, displayBord);
        if (previousBord == null) {
          dailyCandlestick = DailyCandlestick(displayBord!.previousClose!);
        } else if (!dailyCandlestick.alreadySetOpen() &&
            displayBord?.openingPrice != null) {
          dailyCandlestick.setOpenValue(displayBord!.openingPrice!);
        } else if (displayBord?.currentPrice != null) {
          dailyCandlestick.updateValue(displayBord!.currentPrice!);
        }
      }
      notifyListeners();
    });

    final messageTestBox = store.box<MessageTestBox>();
    Query query = messageTestBox.query(MessageTestBox_.id.equals(4)).build();
    final fetchData = query.findFirst();

    if (fetchData != null) {
      listLength = fetchData.messageList.length;
      await Isolate.spawn(sendBordData, {
        'sendPort': sendPort,
        'data': fetchData.messageList,
      });
    }
  }

  _storageReceiveStep(Bord? _previousBord, Bord? _currentBord) {
    // stepデータを格納していきたい
    if (_currentBord?.tradingVolume == null ||
        _currentBord?.tradingVolumeTime == null ||
        _currentBord?.currentPrice == null) {
      return;
    }

    final DateTime tradingVolumeTime =
        DateTime.parse(_currentBord!.tradingVolumeTime!);
    if (receiveSteps.isEmpty) {
      kabuStep.Step _step = kabuStep.Step(
        DateFormat('yyyy-MM-dd').format(tradingVolumeTime),
        DateFormat('HH:mm:ss').format(tradingVolumeTime),
        _currentBord.currentPrice!,
        _currentBord.tradingVolume!.toDouble(),
      );
      _step.isBuy = true;
      receiveSteps.add(_step);
    } else if (_previousBord?.tradingVolume == null ||
        _previousBord?.tradingVolumeTime == null ||
        _previousBord?.currentPrice == null) {
      return;
    } else if (_previousBord!.tradingVolume! != _currentBord.tradingVolume!) {
      kabuStep.Step _step = kabuStep.Step(
        DateFormat('yyyy-MM-dd').format(tradingVolumeTime),
        DateFormat('HH:mm:ss').format(tradingVolumeTime),
        _currentBord.currentPrice!,
        (_currentBord.tradingVolume! - _previousBord.tradingVolume!).toDouble(),
      );
      if (receiveSteps[receiveSteps.length - 1].value <
          _currentBord.currentPrice!) {
        _step.isBuy = true;
      } else if (receiveSteps[receiveSteps.length - 1].value >
          _currentBord.currentPrice!) {
        _step.isBuy = false;
      } else {
        _step.isBuy = receiveSteps[receiveSteps.length - 1].isBuy;
      }
      receiveSteps.add(_step);
    }
  }
}
