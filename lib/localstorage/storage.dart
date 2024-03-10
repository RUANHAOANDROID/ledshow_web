// 检查是否存在token
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> GetAuth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? code = prefs.getString('code');
  return code;
}

Future<void> SaveAuth(String codeNameLimit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('code', codeNameLimit); // 保存token
}

Future<void> RemoveAuth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('code');
}
