import 'package:intl/intl.dart';

class Step {
  Step(
    this.date,
    this.time,
    this.code,
    this.value,
    this.volume,
    this.dayindex,
  ) {
    tradingValue = (value * volume).toInt();
    datetime = DateTime.parse(date + ' ' + time);
  }

  late DateTime datetime;
  final double value;
  final double volume;
  late bool? isBuy;
  late int tradingValue;
  final String date;
  final String time;
  final int code;
  final int dayindex;

  Map<String, dynamic> toMap() {
    return ({
      'code': code,
      'date': date,
      'time': time,
      'dayindex': dayindex,
      'value': value,
      'volume': volume,
    });
  }
}
