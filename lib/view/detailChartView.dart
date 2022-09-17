import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:trade_practice_tool/model/detailChartViewModel.dart';
import 'package:trade_practice_tool/utils/candlesticks/candlesticks.dart';
import 'package:trade_practice_tool/view/widget/bordWidget.dart';
import 'package:trade_practice_tool/view/widget/dailyCandlestickWidget.dart';
import 'package:trade_practice_tool/view/widget/stepWidget.dart';
import 'package:trade_practice_tool/view/widget/tickVolumeWidget.dart';

class DetailChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailChartViewModel>(
      create: (_) => DetailChartViewModel()..receiveBordData(),
      child: Consumer<DetailChartViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '4934 Pアンチ ${model.presentTime} ${model.nowLength}/${model.listLength}'),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final double tickVolumeWidgetHeight = 100;
                final double chartWidth = 700;
                return Row(
                  children: [
                    // チャート
                    Column(
                      children: [
                        SizedBox(
                          // todo:うまく計算する
                          width: chartWidth,
                          height:
                              constraints.maxHeight - tickVolumeWidgetHeight,
                          child: Candlesticks(
                            candles: model.candles,
                            indicators: [
                              model.tickIndicator,
                              model.vwapIndicator,
                            ],
                          ),
                        ),
                        TickVolumeWidget(
                            steps: model.receiveSteps,
                            widgetWidth: chartWidth,
                            widgetHeight: tickVolumeWidgetHeight),
                      ],
                    ),
                    DailyCandlestickWidget(
                      dailyCandlestick: model.dailyCandlestick,
                      width: 20,
                      height: constraints.maxHeight,
                    ),
                    StepWidget(
                      steps: model.receiveSteps,
                      height: constraints.maxHeight,
                    ),
                    // 取引履歴と板
                    Spacer(),
                    Center(
                      child: model.displayBord == null
                          ? Text('no data')
                          : BordWidget(bord: model.displayBord!),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
