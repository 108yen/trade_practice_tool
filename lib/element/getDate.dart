import 'package:intl/intl.dart';

class GetDate {
  GetDate(this.datetime, this.code, this.tick, [this.favorite = false]) {
    this.date = DateFormat('yyyy-MM-dd').format(this.datetime);
  }
  final DateTime datetime;
  late String date;
  final int code;
  final int tick;
  bool favorite;

  Map<String, dynamic> toMap() {
    return ({
      'date': date,
      'code': code,
      'tick': tick,
      'favorite': favorite ? 'true' : 'false',
    });
  }
}
