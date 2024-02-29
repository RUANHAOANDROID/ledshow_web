import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ledshow_web/config.dart';
import '../constants.dart';

class HttpUtils {
  static Dio? dio;
  static var url;

  /// 生成Dio实例
  static Dio getInstance() {
    if (dio == null) {
      //通过传递一个 `BaseOptions`来创建dio实例
      var options = BaseOptions(
          baseUrl: url,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT,
          headers: {
            'Content-Type': 'application/json',
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Expose-Headers":
                "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type",
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Credentials": "true",
          });
      dio = Dio(options);
    }
    return dio!;
  }

  /// 请求api
  static Future<Map<String, dynamic>> request(String path,
      {requestBody, method}) async {
    requestBody = requestBody ?? {};
    method = method ?? "get";
    if (url == null) {
      var config = await loadConfig();
      url = config['address'];
      log(url);
    }
    var dio = getInstance();
    var resp;
    if (method == "get") {
      log(url+path);
      // get
      var response = await dio.get(path);
      log("response code =${response.statusCode}");
      resp = response.data;
    } else {
      // post
      var response = await dio.post(path, data: requestBody);
      log("response code =${response.statusCode}");
      resp = response.data;
    }
    log(" $url$path $method\n ${jsonEncode(requestBody)}\n ${jsonEncode(resp)}");
    return resp;
  }

  /// get
  static Future<Map<String, dynamic>> get(path, data) =>
      request(path, requestBody: data);

  /// post
  static Future<Map<String, dynamic>> post(path, data) =>
      request(path, requestBody: data, method: "post");
}
