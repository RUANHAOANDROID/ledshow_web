import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  final Map<String, Function> _subscribers = {};
  var isConnected = false;
  var wsUrl = "";

  WebSocketProvider(){
    log("Create WebSocketProvider");
  }

  void initConnect(String address){
    // var config = await loadConfig();
    // wsUrl = config["wsUrl"];
    _channel = WebSocketChannel.connect(Uri.parse("ws://$address:6688/ws/hao88"));
    connect();
    isConnected = true;
    log("WebSocket connection $isConnected");
  }

  // Future<String> getUrl() async {
  //   var config = await loadConfig();
  //   return config['address'];
  // }

  void connect() {
    _channel?.stream.listen(
      (message) {
        // 处理收到的WebSocket消息
        isConnected = true;
        //log('Received: $message');
        //debugger(message: message);
        var jsonMap = json.decode(message);
        var id = jsonMap['id'];
        var event = jsonMap['event'];
        var data = jsonMap['data'];
        _subscribers.forEach((key, callback) {
          //debugger(message: key);
          callback(id, event, data);
          //debugPrint("$key -> $message");
        });
      },
      onError: (error) {
        log("WebSocket connection 错误$error");
        isConnected = false;
      },
      onDone: () {
        log('WebSocket connection 断开');
        reConnect();
      },
    );
  }

  void reConnect() {
    disconnect();
    log('WebSocket connection 5秒后重连');
    Future.delayed(const Duration(seconds: 5), () {
      log('WebSocket connection 正在重连');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      connect();
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void subscribe(String key, Function callback) {
    //debugger(message: key);
    _subscribers[key] = callback;
  }

  void sendMsg(String data) {
    _channel?.sink.add(data);
  }

  void unsubscribe(String key) {
    //debugger(message: key);
    _subscribers.remove(key);
  }

  WebSocketChannel? get channel => _channel;
}
