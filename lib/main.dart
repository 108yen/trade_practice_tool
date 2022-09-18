import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trade_practice_tool/view/detailChartView.dart';
import 'package:trade_practice_tool/view/home.dart';
import 'package:trade_practice_tool/view/miniChartsView.dart';

import 'objectbox.g.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  store = await openStore();
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
      // home: Home(),
      home: MiniChartsView(),
      // home: DetailChartView(
      //   symbol: '4934',
      // ),
    );
  }
}
