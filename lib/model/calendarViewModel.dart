import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trade_practice_tool/assets/infoUtils.dart';
import 'package:trade_practice_tool/element/objectBoxEntity.dart';
import 'package:trade_practice_tool/main.dart';
import 'package:trade_practice_tool/objectbox.g.dart';
import 'package:trade_practice_tool/view/chartView.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  late List<String> getDateList;

  CalendarViewModel() {
    final messageBox = store.box<MessageBox>();
    final query = messageBox.query().build();
    getDateList = query.property(MessageBox_.date).find();
    query.close();
  }

  bool isHoliday(DateTime day) {
    return holiday.containsKey(DateFormat('yyyy-MM-dd').format(day));
  }

  bool isEnableDay(DateTime day) {
    return getDateList.indexWhere(
            (element) => element == DateFormat('yyyy-MM-dd').format(day)) !=
        -1;
  }

  onDaySelected(context, selectedDay, focusedDay) {
    print('focusedDay:${selectedDay} this.focusedDay:${this.selectedDay}');
    if (isSameDay(this.selectedDay, selectedDay)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => ChartView(
              replayDate: DateFormat('yyyy-MM-dd').format(focusedDay))),
        ),
      );
    }
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
    notifyListeners();
  }

  setFormat(format) {
    calendarFormat = format;
    notifyListeners();
  }

  Color textColor(DateTime day) {
    const _defaultTextColor = Colors.white;

    if (day.weekday == DateTime.sunday || isHoliday(day)) {
      return Colors.red;
    } else if (day.weekday == DateTime.saturday) {
      return Colors.blue;
    }
    return _defaultTextColor;
  }
}
