import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sunmi_scale/flutter_sunmi_scale.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  static const EventChannel eventChannel = EventChannel(FlutterSunmiScale.EVENT_CHANNEL_NAME);
  SunmiScaleData scaleData = null;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSunmiScale.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onEvent(dynamic data) {
    data = new Map<String, dynamic>.from(data);
    setState(() {
      scaleData = SunmiScaleData.fromJson(data);
    });
  }

  void _onError(Object error) {
    setState(() {
      PlatformException exception = error;
      scaleData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Row(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('重量：${scaleData?.net}')
            ],
          ),
        ),
      ),
    );
  }
}
