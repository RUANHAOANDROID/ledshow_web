import 'package:flutter/material.dart';
import 'package:ledshow_web/localstorage/storage.dart';
import 'package:ledshow_web/provider/ThemeProvider.dart';
import 'package:ledshow_web/provider/WebSocketProvider.dart';
import 'package:ledshow_web/screens/login/login_page.dart';
import 'package:ledshow_web/screens/main/min_page.dart';
import 'package:provider/provider.dart';

//测试编码 1a2d3
void main() async {
  const myApp = const MyApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WebSocketProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: myApp,
  ));
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
        future: GetAuth(),
        builder: (context, auth) {
          if (auth.connectionState == ConnectionState.done) {
            var data = auth.data;
            if (null != data) {
              var split = data.split("|");
              return MainScreen(split[0], split[1], split[2],split[3]);
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
