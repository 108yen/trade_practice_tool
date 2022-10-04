import 'package:flutter/material.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/view/widget/miniChartWidget.dart';

class MiniChartsWidget extends StatelessWidget {
  final double miniChartWidth = 319;
  final double miniChartHeight = 208;
  final List<ChartParams> miniChartParamsList;
  final TradingHistoryList tradingHistoryList;
  final Function onMinichartTap;

  MiniChartsWidget({
    required this.miniChartParamsList,
    required this.tradingHistoryList,
    required this.onMinichartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: ((context, constraints) {
          final crossAxisCount = constraints.maxWidth ~/ miniChartWidth;
          return Container(
            width: (miniChartWidth + 1) * crossAxisCount,
            child: GridView.builder(
              controller: ScrollController(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 4,
                crossAxisSpacing: 1,
                childAspectRatio: miniChartWidth / miniChartHeight,
              ),
              itemCount: miniChartParamsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: MiniChartWidget(
                    width: miniChartWidth,
                    height: miniChartHeight,
                    miniChartParams: miniChartParamsList[index],
                    tradingHistoryList: tradingHistoryList,
                  ),
                  onTap: () {
                    onMinichartTap(miniChartParamsList[index].symbol);
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
