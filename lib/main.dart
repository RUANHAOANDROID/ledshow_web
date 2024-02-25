import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ledshow_web/localstorage/storage.dart';
import 'package:ledshow_web/screens/login/login_page.dart';
import 'package:ledshow_web/screens/main/min_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GateFlow',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: GetAuthCode(),
        builder: (context, authCode) {
          if (authCode.connectionState == ConnectionState.done) {
            if (null != authCode.data) {
              return MainScreen("${authCode.data}");
            } else {
              return LoginScreen();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
