import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/view/ChartView.dart';
import 'package:trade_practice_tool/view/detailChartView.dart';
import 'package:trade_practice_tool/view/home.dart';
import 'package:trade_practice_tool/view/miniChartsView.dart';

import 'objectbox.g.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  store = await openStore(
      maxDBSizeInKB: 1000 * 1024 * 1024,
      directory: 'E:/Program/trade_practice_tool/lib/assets/objectbox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: ListView(
              children: [
                ListTile(
                  title: Text('データ取得'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => Home()),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('ミニ＋詳細チャート'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => ChartView()),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('test'),
                  onTap: () {
                    final symbolInfoListBox = store.box<SymbolInfoListBox>();
                    final query = symbolInfoListBox.query().build();
                    List<SymbolInfoListBox> allSymbolInfoList = query.find();
                    query.close();
                    SymbolInfoListBox latestSymbolInfoList =
                        allSymbolInfoList.reduce((value, element) =>
                            value.timestamp.isAtSameMomentAs(element.timestamp)
                                ? value
                                : element);
                    for (var item in latestSymbolInfoList.symbolInfoList) {
                      print(item);
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
