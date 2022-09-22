import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/view/detailChartView.dart';
import 'package:trade_practice_tool/view/home.dart';
import 'package:trade_practice_tool/view/miniChartsView.dart';

import 'objectbox.g.dart';

late Store store;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  store = await openStore(maxDBSizeInKB: 1000*1024*1024);
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
                  title: Text('ミニチャート'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => MiniChartsView()),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('詳細チャート'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => DetailChartView(
                              symbol: '5032',
                            )),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('test'),
                  onTap: () {
                    final testbox = store.box<MessageTestBox>();
                    final query =
                        testbox.query(MessageTestBox_.id.equals(6)).build();
                    final messageTestBox = query.findFirst();
                    query.close();
                    final box = store.box<MessageBox>();
                    if (messageTestBox != null) {
                      box.put(MessageBox(
                        date: '2022-09-21',
                        messageList: messageTestBox.messageList,
                      ));
                      print('converted');
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
