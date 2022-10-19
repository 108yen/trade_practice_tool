import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:trade_practice_tool/config.dart';
import 'package:trade_practice_tool/element/regist.dart';
import 'package:trade_practice_tool/element/symbol.dart';
import 'package:trade_practice_tool/exception/kabuapiException.dart';

class Kabuapi {
  static Future<String> getToken() async {
    try {
      final http.Response response = await http.post(
        Uri.http(REST_URL, '/kabusapi/token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'APIPassword': API_PW,
        }),
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      return fetchdata['Token'];
    } catch (e) {
      print(e);
      return "";
    }
  }

  static Future<List<Regist>> remove(
      String apikey, List<Regist> removeList) async {
    List<Regist> _registList = [];

    try {
      final http.Response response = await http.put(
        Uri.http(REST_URL, '/kabusapi/unregister'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': apikey,
        },
        body: json.encode({
          'Symbols': removeList.map((e) => e.toJson()).toList(),
        }),
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      for (var item in fetchdata['RegistList']) {
        _registList.add(Regist.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return _registList;
  }

  static Future<bool> removeAll(String apikey) async {
    try {
      final http.Response response = await http.put(
        Uri.http(REST_URL, '/kabusapi/unregister/all'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': apikey,
        },
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      if (fetchdata['RegistList'].isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Regist>> register(
      String apikey, List<Regist> registList) async {
    List<Regist> _registList = [];

    try {
      final http.Response response = await http.put(
        Uri.http(REST_URL, '/kabusapi/register'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': apikey,
        },
        body: json.encode({
          'Symbols': registList.map((e) => e.toJson()).toList(),
        }),
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      for (var item in fetchdata['RegistList']) {
        _registList.add(Regist.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return _registList;
  }

  static Future<List<Regist>> getRegistList(String apikey) async {
    List<Regist> _registList = [];
    try {
      final http.Response response = await http.put(
        Uri.http(REST_URL, '/kabusapi/register'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': apikey,
        },
        body: json.encode({
          'Symbols': [],
        }),
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      for (var item in fetchdata['RegistList']) {
        _registList.add(Regist.fromJson(item));
      }
    } catch (e) {
      print(e);
    }
    return _registList;
  }

  static Future<Symbol> symbolInfo(String apikey, int symbol) async {
    late Symbol symbolData;

    if (symbol == 101) {
      symbolData = Symbol(
        '',
        0,
        0,
        0,
        false,
        false,
        false,
        false,
        '日経平均',
        1,
        '',
        0,
        '',
        0,
        0,
        '101',
        '日経平均株価',
      );
      
      return symbolData;
    }
    try {
      final http.Response response = await http.get(
        Uri.http(
          REST_URL,
          '/kabusapi/symbol/${symbol}@1',
          {
            'addinfo': 'true',
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'X-API-KEY': apikey,
        },
      );
      if (response.statusCode != 200) {
        throw KabuapiException(response.statusCode, response.body);
      }
      final Map<String, dynamic> fetchdata = json.decode(response.body);
      symbolData = Symbol.fromJson(fetchdata);
    } catch (e) {
      print(e);
    }
    return symbolData;
  }
}
