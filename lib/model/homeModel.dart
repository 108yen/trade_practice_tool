import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/bord.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';

class HomeModel extends ChangeNotifier {
  List<String> bordList = [];

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


