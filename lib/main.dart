import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/view/chartView.dart';
import 'package:trade_practice_tool/view/calendarView.dart';
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
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
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
                        builder: ((context) =>
                            ChartView(replayDate: '2022-09-28')),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('カレンダー'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => calendarView()),
                      ),
                    );
                  },
                ),
                //todo:10/6の朝のデータに5129が入っていないので手動で入れる
              ],
            ),
          );
        }),
      ),
    );
  }
}
