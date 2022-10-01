import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trade_practice_tool/assets/infoUtils.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  final _eventsList = {
    DateTime.now().subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
    DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    DateTime.now().add(Duration(days: 1)): [
      'Event A8',
      'Event B8',
      'Event C8',
      'Event D8'
    ],
    DateTime.now().add(Duration(days: 3)):
        Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
    DateTime.now().add(Duration(days: 7)): [
      'Event A10',
      'Event B10',
      'Event C10'
    ],
    DateTime.now().add(Duration(days: 11)): ['Event A11', 'Event B11'],
    DateTime.now().add(Duration(days: 17)): [
      'Event A12',
      'Event B12',
      'Event C12',
      'Event D12'
    ],
    DateTime.now().add(Duration(days: 22)): ['Event A13', 'Event B13'],
    DateTime.now().add(Duration(days: 26)): [
      'Event A14',
      'Event B14',
      'Event C14'
    ],
  };
  late LinkedHashMap<DateTime, List> _events;

  CalendarViewModel() {
    _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: _getHashCode,
    )..addAll(_eventsList);
  }

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List getEventForDay(DateTime day) {
    return _events[day] ?? [];
  }

  bool isHoliday(DateTime day) {
    return holiday.containsKey(DateFormat('yyyy-MM-dd').format(day));
  }

  bool isEnableDay(DateTime day) {
    return day.day == DateTime(2022, 9, 28).day;
  }

  setDay(selectedDay, focusedDay) {
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
