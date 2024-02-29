import 'dart:convert';
import 'package:flutter/services.dart';
Future<Map<String, dynamic>> loadConfig() async {
  String jsonString = await rootBundle.loadString('assets/config.json');
  Map<String, dynamic> config = json.decode(jsonString);
  return config;
}