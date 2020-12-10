package com.food_court.flutter_sunmi_scale

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterSunmiScalePlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private val METHOD_CHANNEL_NAME = "flutter_sunmi_scale";
    private val EVENT_CHANNEL_NAME = "flutter_sunmi_scale_event";

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var flutterSunmiScaleModule: FlutterSunmiScaleModule

    private val GET_DATA = "getData"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)

        flutterSunmiScaleModule = FlutterSunmiScaleModule(flutterPluginBinding.applicationContext, object : FlutterSunmiScaleModule.ScalePresenterCallback {
            override fun getData(net: Int, tare: Int, isStable: Boolean) {
                eventSink?.success(mapOf(
                        flutterSunmiScaleModule.net to "net",
                        flutterSunmiScaleModule.tare to "tare",
                        flutterSunmiScaleModule.isStable to "isStable"
                ))
            }

            override fun isScaleCanUse(isCan: Boolean) {
                TODO("Not yet implemented")
            }
        });
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == GET_DATA) {
            result.success(mapOf(
                    flutterSunmiScaleModule.net to "net",
                    flutterSunmiScaleModule.tare to "tare",
                    flutterSunmiScaleModule.isStable to "isStable"
            ));
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
