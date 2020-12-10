
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSunmiScale {
  static const METHOD_CHANNEL_NAME = "flutter_sunmi_scale";
  static const EVENT_CHANNEL_NAME = "flutter_sunmi_scale_event";

  static const GET_DATA = "getData";

  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map> getData() async {
    final Map data = await _channel.invokeMethod(GET_DATA);
    return data;
  }
}
