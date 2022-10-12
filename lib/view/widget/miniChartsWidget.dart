import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:trade_practice_tool/element/chartParams.dart';
import 'package:trade_practice_tool/element/tradingHistory.dart';
import 'package:trade_practice_tool/view/widget/miniChartWidget.dart';

class MiniChartsWidget extends StatelessWidget {
  final List<ChartParams> miniChartParamsList;
  final TradingHistoryList tradingHistoryList;
  final Function onMinichartTap;
  final Function exchangeParamListOrder;

  MiniChartsWidget({
    required this.miniChartParamsList,
    required this.tradingHistoryList,
    required this.onMinichartTap,
    required this.exchangeParamListOrder,
  });

  final double miniChartWidth = 319;
  final double miniChartHeight = 208;
  final gridvewKey = GlobalKey();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> reorderbleWidget = List.generate(
      miniChartParamsList.length,
      (index) => MiniChartWidget(
        key: Key(miniChartParamsList[index].symbol),
        width: miniChartWidth,
        height: miniChartHeight,
        miniChartParams: miniChartParamsList[index],
        tradingHistoryList: tradingHistoryList,
        onTap: (symbol) {
          onMinichartTap(symbol);
        },
      ),
    );
    // miniChartParamsList
    //     .map(
    //       (e) => MiniChartWidget(
    //         key: Key(e),
    //         width: miniChartWidth,
    //         height: miniChartHeight,
    //         miniChartParams: e,
    //         tradingHistoryList: tradingHistoryList,
    //         onTap: (symbol) {
    //           onMinichartTap(symbol);
    //         },
    //       ),
    //     )
    //     .toList();

    return Scaffold(
      body: LayoutBuilder(
        builder: ((context, constraints) {
          final crossAxisCount = constraints.maxWidth ~/ miniChartWidth;
          return Container(
            width: (miniChartWidth + 1) * crossAxisCount,
            child: ReorderableBuilder(
              children: reorderbleWidget,
              scrollController: scrollController,
              onDragStarted: () {
                print('dragging');
              },
              onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
                exchangeParamListOrder(orderUpdateEntities);
              },
              builder: (List<Widget> children) {
                return GridView.builder(
                  key: gridvewKey,
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 1,
                    childAspectRatio: miniChartWidth / miniChartHeight,
                  ),
                  itemCount: children.length,
                  itemBuilder: (BuildContext context, int index) {
                    return children[index];
                  },
                );
              },
            ),
            // child: GridView.builder(
            //   controller: ScrollController(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: crossAxisCount,
            //     mainAxisSpacing: 4,
            //     crossAxisSpacing: 1,
            //     childAspectRatio: miniChartWidth / miniChartHeight,
            //   ),
            //   itemCount: miniChartParamsList.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return GestureDetector(
            //       child: MiniChartWidget(
            //         width: miniChartWidth,
            //         height: miniChartHeight,
            //         miniChartParams: miniChartParamsList[index],
            //         tradingHistoryList: tradingHistoryList,
            //       ),
            //       onTap: () {
            //         onMinichartTap(miniChartParamsList[index].symbol);
            //       },
            //     );
            //   },
            // ),
          );
        }),
      ),
    );
  }
}
