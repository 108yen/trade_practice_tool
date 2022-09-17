import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/objectbox.g.dart';

import '../main.dart';

class DetailChartViewModel extends ChangeNotifier {
  String receiveMessage = '';
  Bord? displayBord;
  Bord? previousBord;
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
}
