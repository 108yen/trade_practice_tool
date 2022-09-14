import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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

class HomeModel extends ChangeNotifier {
  List<String> bordList = [];
  List<Regist> registList = [];
  List<Symbol> symbolInfoList = [];
  final newSymbolController = TextEditingController();
  late String _token;

  Future restApiTest() async {
    _token = await Kabuapi.getToken();
    registList = await Kabuapi.getRegistList(_token);
    List<Symbol> _symbolInfoList = [];
    for (var item in registList) {
      final Symbol symbolInfo =
          await Kabuapi.symbolInfo(_token, int.parse(item.symbol));
      _symbolInfoList.add(symbolInfo);
    }
    symbolInfoList = _symbolInfoList;

    notifyListeners();
  }

  Future register() async {
    if (newSymbolController.text.length == 4 &&
        double.tryParse(newSymbolController.text) != null) {
      registList = await Kabuapi.registerCode(
        _token,
        int.parse(newSymbolController.text),
      );
    }

    notifyListeners();
  }

  Future jsonLoadTest() async {
    String jsonText = await rootBundle.loadString('lib/assets/jsonSample.json');
    Bord bord = Bord.fromJson(json.decode(jsonText));
    bordList.add(json.encode(bord.toJson()));
    print(bord.timeStamp);

    // objectbox使ってみる
    final bordBox = store.box<BordBox>();
    bordBox.put(BordBox(
      code: int.parse(bord.symbol),
      date: DateFormat('yyyy-MM-dd').format(bord.timeStamp),
      bordList: bordList,
    ));
    final List<BordBox> getAll = bordBox.getAll();
    for (var item in getAll) {
      for (var bordItem in item.bordList) {
        print(bordItem);
        Bord.fromJson(json.decode(bordItem));
      }
      // print(item.bordList[0]);
    }
    // bordBox.removeAll();
  }
}
