import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_practice_tool/config.dart';
import 'package:trade_practice_tool/model/ChartViewModel.dart';
import 'package:trade_practice_tool/view/widget/detailChartWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartsWidget.dart';

class ChartView extends StatelessWidget {
  final String replayDate;
  ChartView({
    required this.replayDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChartViewModel>(
      create: (_) => ChartViewModel(replayDate:replayDate)..setSampleData(),
      child: Consumer<ChartViewModel>(
        builder: ((context, model, child) {
          return Scaffold(
            body: LayoutBuilder(
              builder: ((context, constraints) {
                return model.detailChartIndex == null
                    ? MiniChartsWidget(
                        miniChartParamsList: model.miniChartParamsList,
                        onMinichartTap: (e) {
                          model.setDetailChartIndex(e);
                        },
                      )
                    : Row(
                        children: [
                          Container(
                            width: 319,
                            height: constraints.maxHeight,
                            child: MiniChartsWidget(
                              miniChartParamsList: model.miniChartParamsList,
                              onMinichartTap: (e) {
                                model.setDetailChartIndex(e);
                              },
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth - 319,
                            height: constraints.maxHeight,
                            child: DetailChartWidget(
                              chartParams: model
                                  .miniChartParamsList[model.detailChartIndex!],
                              tradingHistoryList: model.tradingHistoryList,
                              onBackTap: () => model.setDetailChartIndexNull(),
                              onBuy: () => model.buy(),
                            ),
                          ),
                        ],
                      );
              }),
            ),
          );
        }),
      ),
    );
  }
}
