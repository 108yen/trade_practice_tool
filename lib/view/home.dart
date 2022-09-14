import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/model/homeModel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..restApiTest(),
      child: Consumer<HomeModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: ListView(
                    children: model.symbolInfoList
                        .map((e) => ListTile(
                              title: Text(
                                '${e.symbol} ${e.displayName}',
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(labelText: '銘柄コード'),
                        controller: model.newSymbolController,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        model.register();
                      },
                      child: Text('追加'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
