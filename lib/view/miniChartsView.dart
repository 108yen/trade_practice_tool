import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_practice_tool/model/miniChartsViewModel.dart';
import 'package:trade_practice_tool/view/widget/miniChartWidget.dart';

class MiniChartsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MiniChartsModel>(
      create: (_) => MiniChartsModel()..setSampleData(),
      child: Consumer<MiniChartsModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Center(
              child: MiniChartWidget(
                width: model.width,
                height: model.height,
                candles: model.candles,
                dailyCandlestick: model.dailyCandlestick,
                indicators: [model.vwapIndicator],
                bord: model.bord,
              ),
            ),
          );
        },
      ),
    );
  }
}
