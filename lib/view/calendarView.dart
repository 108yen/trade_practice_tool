import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trade_practice_tool/model/calendarViewModel.dart';
import 'package:trade_practice_tool/theme/theme_data.dart';

class calendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarViewModel>(
      create: (_) => CalendarViewModel(),
      child: Consumer<CalendarViewModel>(
        builder: ((context, model, child) {
          return Scaffold(
            body: TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: model.focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(model.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                model.onDaySelected(context,selectedDay, focusedDay);
              },
              calendarFormat: model.calendarFormat,
              onFormatChanged: (format) {
                model.setFormat(format);
              },
              holidayPredicate: model.isHoliday,
              enabledDayPredicate: model.isEnableDay,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.all(1),
                    color: Theme.of(context).background,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: model.textColor(day),
                        ),
                      ),
                    ),
                  );
                },
                disabledBuilder: (context, day, focusedDay) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.all(1),
                    color: Colors.black26,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: model.textColor(day),
                        ),
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.all(1),
                    color: Colors.black26,
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: model.textColor(day),
                        ),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  if (model.isEnableDay(day)) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.all(1),
                      color: Theme.of(context).background,
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF5C6BC0),
                          ),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                color: model.textColor(day),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF5C6BC0),
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: model.textColor(day),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                dowBuilder: (context, day) {
                  final text = DateFormat.E().format(day);
                  late Color textColor;
                  if (day.weekday == DateTime.sunday) {
                    textColor = Colors.red;
                  } else if (day.weekday == DateTime.saturday) {
                    textColor = Colors.blue;
                  } else {
                    textColor = Colors.white;
                  }
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: textColor),
                    ),
                  );
                },
                holidayBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).grayColor,
                        ),
                        width: 10.0,
                        height: 10.0,
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
