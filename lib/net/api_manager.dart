import 'dart:async';

import 'package:ledshow_web/net/http.dart';

class ApiManager {
  static Future reconnect() async {
    await HttpUtils.get("/reconnect", "");
  }
}
