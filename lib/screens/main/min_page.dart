import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledshow_web/models/LedParameters.dart';

class MainScreen extends StatefulWidget {
  final String authCode;

  MainScreen(this.authCode);

  @override
  State<StatefulWidget> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<MainScreen> {
  var leds = List.empty(growable: true);

  @override
  void dispose() {
    super.dispose();
    leds.add(LedParameters());
    leds.add(LedParameters());
  }

  @override
  Widget build(BuildContext context) {
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
                  "限流：${"500"}",
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
        "神龙顶风景区(${widget.authCode})",
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

class TwoColumnList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 指定列数为2
        crossAxisSpacing: 10.0, // 列之间的水平间距
        mainAxisSpacing: 10.0, // 行之间的垂直间距
      ),
      itemCount: 20, // 假设有20个项目
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Item $index'),
            subtitle: Text('Description of Item $index'),
            onTap: () {
              // 处理项目点击事件
            },
          ),
        );
      },
    );
  }
}
