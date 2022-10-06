import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trade_practice_tool/api/kabuapi.dart';
import 'package:trade_practice_tool/config.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/element/regist.dart';
import 'package:trade_practice_tool/element/symbol.dart';
import 'package:trade_practice_tool/exception/kabuapiException.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:web_socket_channel/io.dart';

class HomeModel extends ChangeNotifier {
  List<String> bordList = [];
  List<Regist> registList = [];
  List<Symbol> symbolInfoList = [];
  List<String> messageList = [];
  final newSymbolController = TextEditingController();
  late String _token;

  websocketTest() async {
    final channel = IOWebSocketChannel.connect(Uri.parse(WEBSOCKET_URL));

    channel.stream.listen((message) {
      messageList.add('{"timestamp":"${DateTime.now()}","message":${message}}');
    }, onDone: () {
      print('websocket channel closed');
    }, onError: (error) {
      print('websocket error occurred:${error}');
    });
  }

  Future saveMessageList() async {
    final messageBox = store.box<MessageBox>();

    messageBox.put(MessageBox(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      messageList: messageList,
    ));
    print('save data');
  }

  Future restApiTest() async {
    _token = await Kabuapi.getToken();
    List<Regist> _previousRegistList = [];
    final symbolInfoListBox = store.box<SymbolInfoListBox>();
    final query = symbolInfoListBox.query().build();
    List<SymbolInfoListBox> allSymbolInfoList = query.find();
    query.close();
    SymbolInfoListBox latestSymbolInfoList = allSymbolInfoList.reduce((value,
            element) =>
        value.timestamp.isAtSameMomentAs(element.timestamp) ? value : element);
    if (latestSymbolInfoList != null) {
      _previousRegistList = latestSymbolInfoList.symbolInfoList.map((e) {
        final preSym = Symbol.fromJson(json.decode(e));
        return Regist(symbol: preSym.symbol, exchange: preSym.exchange);
      }).toList();
      symbolInfoList = latestSymbolInfoList.symbolInfoList
          .map((e) => Symbol.fromJson(json.decode(e)))
          .toList();
    }
    notifyListeners();

    registList = await Kabuapi.register(_token, _previousRegistList);
    symbolInfoList = await _getSymbolInfoList(registList);
  }

  Future removeAll() async {
    await Kabuapi.removeAll(_token);
    registList = await Kabuapi.getRegistList(_token);
  }

  Future remove(String symbol) async {
    final int infoIndex =
        symbolInfoList.indexWhere((element) => element.symbol == symbol);
    if (infoIndex != -1) {
      registList = await Kabuapi.remove(
        _token,
        [
          Regist(
            symbol: symbol,
            exchange: 1,
          ),
        ],
      );
      symbolInfoList.removeAt(infoIndex);

      final symbolInfoListBox = store.box<SymbolInfoListBox>();
      symbolInfoListBox.put(SymbolInfoListBox(
        timestamp: DateTime.now(),
        symbolInfoList:
            symbolInfoList.map((e) => json.encode(e.toJson())).toList(),
      ));
    }
    for (var item in registList) {
      print(item.symbol);
    }

    notifyListeners();
  }

  Future<List<Symbol>> _getSymbolInfoList(List<Regist> _registList) async {
    List<Symbol> _symbolInfoList = [];
    List<String> _symbolInfoJsonList = [];
    int index = 1;
    for (var item in registList) {
      final Symbol symbolInfo =
          await Kabuapi.symbolInfo(_token, int.parse(item.symbol));
      _symbolInfoList.add(symbolInfo);
      _symbolInfoJsonList.add(json.encode(symbolInfo.toJson()));
      EasyLoading.showProgress(index / registList.length,
          status: '${(100 * index / registList.length).toStringAsFixed(0)} %');
      index += 1;
    }
    EasyLoading.dismiss();

    final symbolInfoListBox = store.box<SymbolInfoListBox>();
    symbolInfoListBox.put(SymbolInfoListBox(
      timestamp: DateTime.now(),
      symbolInfoList: _symbolInfoJsonList,
    ));
    return _symbolInfoList;
  }

  Future register() async {
    if (newSymbolController.text.length == 4 &&
        double.tryParse(newSymbolController.text) != null) {
      registList = await Kabuapi.register(
        _token,
        [
          Regist(
            symbol: newSymbolController.text,
            exchange: 1,
          ),
        ],
      );
      if (symbolInfoList.indexWhere(
              (element) => element.symbol == newSymbolController.text) ==
          -1) {
        final Symbol symbolInfo = await Kabuapi.symbolInfo(
            _token, int.parse(newSymbolController.text));
        symbolInfoList.add(symbolInfo);

        final symbolInfoListBox = store.box<SymbolInfoListBox>();
        symbolInfoListBox.put(SymbolInfoListBox(
          timestamp: DateTime.now(),
          symbolInfoList:
              symbolInfoList.map((e) => json.encode(e.toJson())).toList(),
        ));
      }
    }
    newSymbolController.text = '';

    notifyListeners();
  }

  // Future jsonLoadTest() async {
  //   String jsonText = await rootBundle.loadString('lib/assets/jsonSample.json');
  //   Bord bord = Bord.fromJson(json.decode(jsonText));
  //   bordList.add(json.encode(bord.toJson()));
  //   print(bord.timeStamp);

  //   // objectbox使ってみる
  //   final bordBox = store.box<BordBox>();
  //   bordBox.put(BordBox(
  //     code: int.parse(bord.symbol),
  //     date: DateFormat('yyyy-MM-dd').format(bord.timeStamp),
  //     bordList: bordList,
  //   ));
  //   final List<BordBox> getAll = bordBox.getAll();
  //   for (var item in getAll) {
  //     for (var bordItem in item.bordList) {
  //       print(bordItem);
  //       Bord.fromJson(json.decode(bordItem));
  //     }
  //     // print(item.bordList[0]);
  //   }
  //   // bordBox.removeAll();
  // }
}
