import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ledshow_web/models/LedParameters.dart';
import 'package:ledshow_web/models/Resp.dart';
import 'package:ledshow_web/net/http.dart';
import 'package:ledshow_web/provider/WebSocketProvider.dart';
import 'package:ledshow_web/widget/mytoast.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final String authCode;
  final String name;
  final String limitsCount;
  WebSocketProvider? webSocketProvider;

  MainScreen(this.authCode, this.name, this.limitsCount);

  @override
  State<StatefulWidget> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<MainScreen> {
  String inCount = "0";
  String existCount = "0";
  List<LedParameters> leds = List.empty(growable: true);

  void getLedList() async {
    try {
      var resp = await HttpUtils.get("/leds/${widget.authCode}", "");
      int code = resp["code"];
      if (code == SUCCESS) {
        leds.clear();
        setState(() {
          List<dynamic> items = resp['data'];
          for (var item in items) {
            var parameters = LedParameters();
            parameters.name = item["name"];
            parameters.height = item["h"];
            parameters.width = item["w"];
            parameters.x = item["x"];
            parameters.y = item["y"];
            parameters.fontSize = item["fontSize"];
            parameters.ip = item["ip"];
            parameters.port = item["port"];
            leds.add(parameters);
          }
        });
      }
    } catch (e) {
      log("$e");
      FToast()
          .init(context)
          .showToast(child: MyToast(tip: "获取LED失败$e", ok: false));
    }
  }

  void reconnect(String ip) async {
    try {
      var resp = await HttpUtils.get("/recon/$ip", "");
      int code = resp["code"];
      if (code == SUCCESS) {
        setState(() {});
      }
    } catch (e) {
      log("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    getLedList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.webSocketProvider = Provider.of<WebSocketProvider>(context);
    widget.webSocketProvider?.subscribe("home", (id, event, data) {
      log("message id=$id , event=$event, data=$data");
      switch (event) {
        case "LED":
          for (var led in leds) {
            if (led.ip == id) {
              setState(() {
                led.status = data;
              });
            }
          }
          break;
        case "IN":
          setState(() {
            inCount = data;
          });
          break;
        case "EXIST":
          setState(() {
            existCount = data;
          });
          break;
      }
    });
  }

  Function wsCall() {
    return (id, event, data) {};
  }

  @override
  void dispose() {
    widget.webSocketProvider?.unsubscribe("home");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("build");
    // ApiManager.getStream("request");

    List<Widget> widgets() {
      List<Widget> widgets = List.empty(growable: true);
      var infoCard = Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "限流：${widget.limitsCount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "今日接待：${inCount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "当前在园：${existCount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
      widgets.add(Text(
        "${widget.name}(${widget.authCode})",
        style: Theme.of(context).textTheme.titleLarge,
      ));
      widgets.add(const SizedBox(height: 8));
      widgets.add(infoCard);
      widgets.add(const SizedBox(height: 16));
      widgets.add(Text(
        "LED",
        style: Theme.of(context).textTheme.titleLarge,
      ));
      Column createLedCard() {
        return Column();
      }

      if (leds.isNotEmpty) {
        for (var led in leds) {
          widgets.add(Card(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "点位：${led.name}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "IP：${led.ip}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              reconnect(led.ip);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.blue,
                            ),
                            label: Text(
                              "重连",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "状态：",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "${led.status}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.apply(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
          widgets.add(const SizedBox(height: 8));
        }
      }
      return widgets; // all widget added now retrun the list here
    }

    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: widgets(),
        ),
      ),
    ));
  }
}
