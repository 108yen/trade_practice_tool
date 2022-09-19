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
            body: LayoutBuilder(
              builder: ((context, constraints) {
                final crossAxisCount =
                    constraints.maxWidth ~/ model.miniChartWidth;
                return Container(
                  width: (model.miniChartWidth + 1) * crossAxisCount,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 1,
                      childAspectRatio:
                          model.miniChartWidth / model.miniChartHeight,
                    ),
                    itemCount: model.miniChartParamsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MiniChartWidget(
                        width: model.miniChartWidth,
                        height: model.miniChartHeight,
                        miniChartParams: model.miniChartParamsList[index],
                      );
                    },
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
