// 检查是否存在token
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

Future<String?> GetAuthCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? code = prefs.getString('code');
  debugger(message: code);
  return code;
}

Future<void> SaveAuthCode(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('code', code); // 保存token
  debugger(message: code);
}
