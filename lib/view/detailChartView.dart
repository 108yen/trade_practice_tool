import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/model/detailChartViewModel.dart';
import 'package:trade_practice_tool/view/widget/bordWidget.dart';

class DetailChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailChartViewModel>(
      create: (_) => DetailChartViewModel()..receiveBordData(),
      child: Consumer<DetailChartViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('4934 Pアンチ ${model.presentTime}'),
            ),
            body: Center(
              child: model.displayBord == null
                  ? Text('no data')
                  : BordWidget(bord: model.displayBord!),
            ),
          );
        },
      ),
    );
  }
}
