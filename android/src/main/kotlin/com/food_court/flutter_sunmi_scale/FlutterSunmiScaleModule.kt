package com.food_court.flutter_sunmi_scale

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.os.RemoteException
import android.util.Log
import android.widget.Toast
import com.sunmi.scalelibrary.ScaleManager
import com.sunmi.scalelibrary.ScaleManager.ScaleServiceConnection
import com.sunmi.scalelibrary.ScaleResult
import java.text.DecimalFormat


class FlutterSunmiScaleModule(val context: Context, val callback: ScalePresenterCallback) {
    private val decimalFormat = DecimalFormat("0.000")
    private val uiThreadHandler = Handler(Looper.getMainLooper())

    private var mScaleManager: ScaleManager? = null

    var scaleData: ScaleData = ScaleData();

    class ScaleData {
        var isCanUse: Boolean = false

        var net: Int = 0
        var tare: Int = 0
        var isStable: Boolean = false

        var isLightWeight: Boolean = false
        var overload: Boolean = false
        var clearZeroErr: Boolean = false
        var calibrationErr: Boolean = false
    }

    interface ScalePresenterCallback {
        fun getData(data: ScaleData)
    }

    fun connectScaleService() {
        mScaleManager = ScaleManager.getInstance(context);
        mScaleManager?.connectService(object : ScaleServiceConnection {
            override fun onServiceConnected() {
                getScaleData()
            }

            override fun onServiceDisconnect() {
                scaleData.isCanUse = false
                callback.getData(scaleData)
            }
        })
    }

    private fun getScaleData() {
        mScaleManager!!.getData(object : ScaleResult() {
            override fun getResult(p0: Int, p1: Int, p2: Boolean) {
                // p0 = 净重量 单位 克 ，p1 = 皮重量 单位 克 ，p2 = 稳定状态。具体其他状态请参考商米开发者文档
                Log.d("SUNMI",
                        "update: -----------------> 净重：" + decimalFormat.format((p0 * 1.0f / 1000).toDouble()) +
                                ", 皮重：" + decimalFormat.format((p1 * 1.0f / 1000).toDouble()) +
                                ", 稳定：" + (if (p2) "稳定" else "不稳定")
                )

                scaleData.isCanUse = true
                scaleData.net = p0
                scaleData.tare = p1
                scaleData.isStable = p2

                uiThreadHandler.post { callback.getData(scaleData) }
            }

            override fun getStatus(p0: Boolean, p1: Boolean, p2: Boolean, p3: Boolean) {
                scaleData.isLightWeight = p0
                scaleData.overload = p1
                scaleData.clearZeroErr = p2
                scaleData.calibrationErr = p3

                uiThreadHandler.post { callback.getData(scaleData) }
            }
        })
    }

    /**
     * 清皮
     */
    fun clearTare() {
        if (scaleData.tare + scaleData.net == 0 && scaleData.isCanUse) {
            tare()
        } else {
            Toast.makeText(context, R.string.scale_tips_clearfail, Toast.LENGTH_LONG).show()
        }
    }

    /**
     * 数字皮重
     *
     * @param numTare
     */
    fun setNumTare(numTare: Int) {
        if (numTare > 0 && numTare <= 5998) {
            if (scaleData.isCanUse) {
                try {
                    mScaleManager!!.digitalTare(numTare)
                } catch (e: RemoteException) {
                    e.printStackTrace()
                }
            }
        }
    }

    /**
     * 去皮
     */
    fun tare() {
        try {
            if (scaleData.isCanUse) {
                mScaleManager!!.tare()
                Toast.makeText(context, if (scaleData.tare == 0) R.string.scale_more_peele else R.string.scale_more_clear_peele, Toast.LENGTH_LONG).show()
            }
        } catch (e: RemoteException) {
            e.printStackTrace()
        }
    }

    /**
     * 清零
     */
    fun zero() {
        try {
            if (scaleData.isCanUse) {
                mScaleManager!!.zero()
                Toast.makeText(context, R.string.scale_more_clear, Toast.LENGTH_LONG).show()
            }
        } catch (e: RemoteException) {
            e.printStackTrace()
        }
    }
}