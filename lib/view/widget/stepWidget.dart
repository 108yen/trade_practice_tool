import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trade_practice_tool/element/step.dart' as kabustep;

class StepWidget extends StatelessWidget {
  final List<kabustep.Step> steps;
  late List<kabustep.Step> reversedSteps;
  final double width;
  final double height;

  StepWidget({
    required this.steps,
    this.width = 200,
    required this.height,
  }) {
    this.reversedSteps = steps.reversed.toList();
  }

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
          child: ListView.builder(
            itemCount: steps.length,
            controller: ScrollController(),
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                height: 15,
                child: Center(
                  child: Row(
                    children: [
                      SizedBoxText(65, TextAlign.right,
                          '${DateFormat('HH:mm:ss').format(reversedSteps[index].datetime)}'),
                      SizedBoxText(
                          60, TextAlign.right, '${reversedSteps[index].value}'),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '${reversedSteps[index].volume.floor()}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: reversedSteps[index].isBuy!
                                  ? Colors.red
                                  : Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
