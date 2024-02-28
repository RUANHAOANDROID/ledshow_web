import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ledshow_web/models/LedParameters.dart';
import 'package:ledshow_web/provider/WebSocketProvider.dart';
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
  var leds = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    leds.add(LedParameters());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.webSocketProvider = Provider.of<WebSocketProvider>(context);
    widget.webSocketProvider?.subscribe("home", (id, event, data) {
      log("message id=$id , event=$event, data=$data");
      if (event == "LED") {
        for (var led in leds) {
          if (led.ip == id) {
            led.status = data;
            setState(() {
              log("刷新");
            });
          }
        }
      }
    });
  }

  Function wsCall() {
    return (id, event, data) {};
  }

  @override
  void dispose() {
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
                  "今日接待：${"500"}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "当前在园：${"500"}",
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
      var ledCard = Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "点位：${"东桥LED"}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "IP：${"192.168.9.199"}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton.icon(
                        onPressed: () {},
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
                      "${"ACK-正确"}",
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
      );
      widgets.add(ledCard);
      widgets.add(const SizedBox(height: 8));
      widgets.add(ledCard);
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
