import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledshow_web/localstorage/storage.dart';

import '../main/min_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String authCode = "";

  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      onChanged: (value) {
        authCode = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '授权码为空';
        }
        return null;
      },
      decoration: InputDecoration(
          hoverColor: Theme.of(context).highlightColor,
          //labelStyle: formTextStyle(context),
          //hintStyle: formTextStyle(context),
          border: const OutlineInputBorder(),
          labelText: '景点编号',
          hintText: '请输入景点编号'),
    );
    var container = Container(
      constraints: const BoxConstraints(
          minWidth: 500.0, minHeight: 500.0, maxWidth: 600.0, maxHeight: 600.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "限流服务",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 100.0, right: 100.0, top: 32.0, bottom: 64.0),
            child: textFormField,
          ),
          ElevatedButton(
              onPressed: () async {
                await SaveAuthCode(authCode);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(authCode)),
                  (route) => route == null,
                );
              },
              child: const Text("进入"))
        ],
      ),
    );
    var center = Center(
        child: Card(
      elevation: 5,
      child: container,
    ));
    return Scaffold(
      body: center,
    );
  }
}
