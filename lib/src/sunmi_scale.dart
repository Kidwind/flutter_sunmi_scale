
import 'dart:async';

import 'package:flutter/services.dart';

import 'sunmi_scale_data.dart';

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

  static Future<SunmiScaleData> getData() async {
    final Map<String, dynamic> data = await _channel.invokeMethod(GET_DATA);
    return SunmiScaleData.fromJson(data);
  }
}
