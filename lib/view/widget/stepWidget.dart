import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/step.dart' as kabustep;

class StepWidget extends StatelessWidget {
  final List<kabustep.Step> steps;
  final double width;
  final double height;

  StepWidget({
    required this.steps,
    this.width = 200,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: 18,
          child: Center(
            child: Row(
              children: [
                SizedBoxText(65, TextAlign.center, '時刻'),
                SizedBoxText(60, TextAlign.center, '約定価格'),
                SizedBoxText(60, TextAlign.center, '出来高'),
              ],
            ),
          ),
        ),
        Container(
          width: width,
          height: height - 18,
          child: ListView(
              children: steps.isEmpty
                  ? []
                  : steps.reversed
                      .toList()
                      .sublist(0, steps.length < 100 ? steps.length - 1 : 100)
                      .map((e) => Container(
                            width: 200,
                            height: 15,
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBoxText(65, TextAlign.right,
                                      '${DateFormat('HH:mm:ss').format(e.datetime)}'),
                                  SizedBoxText(
                                      60, TextAlign.right, '${e.value}'),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      '${e.volume.floor()}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: e.isBuy!
                                              ? Colors.red
                                              : Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList()),
        ),
      ],
    );
  }

  Widget SizedBoxText(double width, TextAlign textAlign, var str) {
    return SizedBox(
      width: width,
      child: (Text(
        str,
        textAlign: textAlign,
      )),
    );
  }
}
