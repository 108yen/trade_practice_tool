import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:trade_practice_tool/element/getDate.dart';
import 'package:trade_practice_tool/element/step.dart';
import '../config.dart';
import 'package:intl/intl.dart';

class RaspiDB {
  static Future _dbConnect() async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: DB_HOST,
      port: DB_PORT,
      user: DB_USER,
      db: DB,
      password: DB_PW,
    ));
  }

  static Future<List<Step>> getStep(String date, int code) async {
    // Open a connection (testdb should already exist)
    final conn = await _dbConnect();

    var fetchData = await conn.query(
        'SELECT cast(date as char),cast(time as char),code,value,volume,dayindex FROM step WHERE (`date` IN (\'$date\')) AND (code=$code) ORDER BY dayindex DESC');
    List<Step> results = [];
    for (var row in fetchData) {
      results.add(Step(
        row[0],
        row[1],
        row[3],
        row[4],
      ));
    }
    await conn.close();

    return results;
  }

  static Future<bool> getDataExist(int code, String date) async {
    final conn = await _dbConnect();

    final fetchData = await conn.query(
        'SELECT * FROM getdate WHERE code=${code} AND (`date` IN (\'$date\'))');
    await conn.close();
    // print(fetchData.runtimeType);
    List<GetDate> getDateList=[];
    for (var item in fetchData) {
      getDateList.add(GetDate(item[0], item[1], item[2]));
    }

    return getDateList.length != 0 && getDateList[0].tick != 0;
  }
}
