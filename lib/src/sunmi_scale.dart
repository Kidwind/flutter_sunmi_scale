
import 'dart:async';

import 'package:flutter/services.dart';

import 'sunmi_scale_data.dart';

class FlutterSunmiScale {
  static const METHOD_CHANNEL_NAME = "flutter_sunmi_scale";
  static const EVENT_CHANNEL_NAME = "flutter_sunmi_scale_event";

  static const GET_DATA = "getData";
  static const ZERO = "zero";
  static const TARE = "tare";
  static const SET_NUM_TARE = "setNumTare";
  static const CLEAR_TARE = "clearTare";

  static const MethodChannel _channel =
  const MethodChannel(METHOD_CHANNEL_NAME);

  static Future<SunmiScaleData> getData() async {
    final Map<String, dynamic> data = await _channel.invokeMethod(GET_DATA);
    return SunmiScaleData.fromJson(data);
  }

  static Future<void> zero() async {
    await _channel.invokeMethod(ZERO);
  }

  static Future<void> tare() async {
    await _channel.invokeMethod(TARE);
  }

  static Future<void> setNumTare(int numTare) async {
    await _channel.invokeMethod(SET_NUM_TARE, { "numTare": numTare });
  }

  static Future<void> clearTare() async {
    await _channel.invokeMethod(CLEAR_TARE);
  }
}
