import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ledshow_web/localstorage/storage.dart';
import 'package:ledshow_web/models/Resp.dart';
import 'package:ledshow_web/net/http.dart';
import 'package:ledshow_web/widget/mytoast.dart';

import '../main/min_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String authCode = "";
  String name = "";
  String limit = "";

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
    var card = Card(
      elevation: 5,
      child: Container(
        constraints: const BoxConstraints(
            minWidth: 500.0,
            minHeight: 500.0,
            maxWidth: 600.0,
            maxHeight: 600.0),
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
                  if (authCode == "") {
                    FToast()
                        .init(context)
                        .showToast(child: const MyToast(tip: "编号为空", ok: false));
                    return;
                  }
                  var isHanzi = RegExp(r'[\u4e00-\u9fa5]').hasMatch(authCode);
                  if (isHanzi) {
                    FToast().init(context).showToast(
                        child: const MyToast(tip: "输入错误 编号由a~y,0~9组成", ok: false));
                    return;
                  }
                  var ok = await auth(authCode);
                  if (ok) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainScreen(authCode, name, "${limit}")),
                      (route) => route == null,
                    );
                  }
                },
                child: const Text("进入"))
          ],
        ),
      ),
    );
    return Scaffold(
      body: Center(child: card),
    );
  }

  Future<bool> auth(code) async {
    try {
      log("auth----");
      var resp = await HttpUtils.get("/auth/$authCode", "");
      var code = resp["code"];
      log("resp----${resp}");
      if (code == SUCCESS) {
        name = resp["data"]["name"];
        limit = resp["data"]["limitsCount"];
        await SaveAuth("$authCode|${name}|${limit}");
        return true;
      } else {
        FToast()
            .init(context)
            .showToast(child: MyToast(tip: "${resp["msg"]}", ok: false));
        return false;
      }
    } catch (e) {
      log("error----${e}");
      FToast().init(context).showToast(child: MyToast(tip: "${e}", ok: false));
      return false;
    }
  }
}
