
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'tianqi_model.dart';

class TianqiHttp {
  static Future getTianqiHttp(String cityName) async {
    String url = 'https://www.tianqiapi.com/api?action=v6&appid=62472739&appsecret=ZCdZQe5r&city=${cityName}';
    try{
      Response response = await Dio().get(url);
      var json = jsonDecode(response.toString());
      return TianqiModel.fromJson(json);
    }catch(e) {
      print('错误$e');
    }
  }
}