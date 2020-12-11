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
    private val ZERO = "zero"
    private val TARE = "tare"
    private val SET_NUM_TARE = "setNumTare"
    private val CLEAR_TARE = "clearTare"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)

        flutterSunmiScaleModule = FlutterSunmiScaleModule(flutterPluginBinding.applicationContext, object : FlutterSunmiScaleModule.ScalePresenterCallback {
            override fun getData(scaleData: FlutterSunmiScaleModule.ScaleData) {
                eventSink?.success(mapOf(
                        "isCanUse" to scaleData.isCanUse,

                        "net" to scaleData.net,
                        "tare" to scaleData.tare,
                        "isStable" to scaleData.isStable,

                        "isLightWeight" to scaleData.isLightWeight,
                        "overload" to scaleData.overload,
                        "clearZeroErr" to scaleData.clearZeroErr,
                        "calibrationErr" to scaleData.calibrationErr
                ))
            }
        });
        flutterSunmiScaleModule.connectScaleService()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == GET_DATA) {
            val scaleData = flutterSunmiScaleModule.scaleData;
            result.success(mapOf(
                    "isCanUse" to scaleData.isCanUse,

                    "net" to scaleData.net,
                    "tare" to scaleData.tare,
                    "isStable" to scaleData.isStable,

                    "isLightWeight" to scaleData.isLightWeight,
                    "overload" to scaleData.overload,
                    "clearZeroErr" to scaleData.clearZeroErr,
                    "calibrationErr" to scaleData.calibrationErr
            ));
        } else if (call.method == ZERO) {
            flutterSunmiScaleModule.zero()
        } else if (call.method == TARE) {
            flutterSunmiScaleModule.tare()
        } else if (call.method == SET_NUM_TARE) {
            call.argument<Int>("numTare")?.let { flutterSunmiScaleModule.setNumTare(it) }
        } else if (call.method == CLEAR_TARE) {
            flutterSunmiScaleModule.clearTare()
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
