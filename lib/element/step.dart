import 'package:intl/intl.dart';

class Step {
  Step(
    this.date,
    this.time,
    this.value,
    this.volume,
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

  Map<String, dynamic> toMap() {
    return ({
      'date': date,
      'time': time,
      'value': value,
      'volume': volume,
    });
  }
}
