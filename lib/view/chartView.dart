import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:provider/provider.dart';
import 'package:trade_practice_tool/config.dart';
import 'package:trade_practice_tool/model/ChartViewModel.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';
import 'package:trade_practice_tool/view/calendarView.dart';
import 'package:trade_practice_tool/view/widget/detailChartWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartWidget.dart';
import 'package:trade_practice_tool/view/widget/miniChartsWidget.dart';
import 'package:trade_practice_tool/view/widget/tradeHistoryPopupWidget.dart';

class ChartView extends StatelessWidget {
  final String replayDate;
  ChartView({
    required this.replayDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChartViewModel>(
      create: (_) => ChartViewModel(replayDate: replayDate)..setSampleData(),
      child: Consumer<ChartViewModel>(
        builder: ((context, model, child) {
          List<Widget> stackWidget = [
            MiniChartsWidget(
              miniChartParamsList: model.miniChartParamsList,
              tradingHistoryList: model.tradingHistoryList,
              onMinichartTap: (e) {
                model.setDetailChartIndex(e);
              },
              exchangeParamListOrder: model.exchangeParamListOrder,
            ),
          ];
          if (model.isPopup) {
            stackWidget.add(TradeHistoryPopupWidget(
              tradingHistoryList: model.tradingHistoryList,
              isolateStatus: model.isolateStatus,
              repalyDate: model.replayDate,
              currentTime: model.currentTime,
              symbolNum: model.miniChartParamsList.length,
              onTapCalendar: () {
                model.stop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => CalendarView()),
                  ),
                );
              },
              onTapReplay: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => ChartView(
                          replayDate: model.replayDate,
                        )),
                  ),
                );
              },
              onTapStart: () {
                if (model.isolateStatus == 0) {
                  model.start();
                } else if (model.isolateStatus == 1 ||
                    model.isolateStatus == 2) {
                  model.resume();
                }
              },
            ));
          }

          return Scaffold(
            body: LayoutBuilder(
              builder: ((context, constraints) {
                return model.detailChartIndex == null
                    ? Stack(
                        children: stackWidget,
                      )
                    : Row(
                        children: [
                          Container(
                            width: 319,
                            height: constraints.maxHeight,
                            child: MiniChartsWidget(
                              miniChartParamsList: model.miniChartParamsList,
                              tradingHistoryList: model.tradingHistoryList,
                              onMinichartTap: (e) {
                                model.setDetailChartIndex(e);
                              },
                              exchangeParamListOrder:
                                  model.exchangeParamListOrder,
                            ),
                          ),
                          Container(
                            width: constraints.maxWidth - 319,
                            height: constraints.maxHeight,
                            child: DetailChartWidget(
                              chartParams: model
                                  .miniChartParamsList[model.detailChartIndex!],
                              tradingHistoryList: model.tradingHistoryList,
                              currentTime: model.currentTime,
                              onBackTap: () => model.setDetailChartIndexNull(),
                              onBuy: () => model.buy(),
                              isolateStatus: model.isolateStatus,
                              onTapStart: () {
                                if (model.isolateStatus == 0) {
                                  model.start();
                                } else if (model.isolateStatus == 1 ||
                                    model.isolateStatus == 2) {
                                  model.resume();
                                }
                              },
                            ),
                          ),
                        ],
                      );
              }),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).grayColor,
              foregroundColor: Colors.white,
              mini: true,
              child: Icon(Icons.menu),
              onPressed: () {
                model.changeIsPopup();
              },
            ),
          );
        }),
      ),
    );
  }
}
