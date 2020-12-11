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
    private var isScaleSuccess: Boolean = false

    var net: Int = 0
        private set
    var tare: Int = 0
        private set
    var isStable: Boolean = false
        private set

    var isLightWeight: Boolean = false
        private set
    var overload: Boolean = false
        private set
    var clearZeroErr: Boolean = false
        private set
    var calibrationErr: Boolean = false
        private set

    interface ScalePresenterCallback {
        fun getData(net: Int, tare: Int, isStable: Boolean)
        fun isScaleCanUse(isCan: Boolean)
    }

    fun connectScaleService() {
        mScaleManager = ScaleManager.getInstance(context);
        mScaleManager?.connectService(object : ScaleServiceConnection {
            override fun onServiceConnected() {
                getScaleData()
            }

            override fun onServiceDisconnect() {
                isScaleSuccess = false
                callback.isScaleCanUse(false)
            }
        })
    }

    private fun getScaleData() {
        mScaleManager!!.getData(object : ScaleResult() {
            override fun getResult(p0: Int, p1: Int, p2: Boolean) {
                // p0 = 净重量 单位 克 ，p1 = 皮重量 单位 克 ，p2 = 稳定状态。具体其他状态请参考商米开发者文档
                Log.d("SUNMI", "update: ----------------->" + decimalFormat.format((p0 * 1.0f / 1000).toDouble()))

                net = p0
                tare = p1
                isStable = p2

                uiThreadHandler.post { callback.getData(p0, p1, p2) }

                if (isScaleSuccess) {
                    return
                }

                isScaleSuccess = true
                uiThreadHandler.post { callback.isScaleCanUse(true) }
            }

            override fun getStatus(p0: Boolean, p1: Boolean, p2: Boolean, p3: Boolean) {
                isLightWeight = p0
                overload = p1
                clearZeroErr = p2
                calibrationErr = p3
            }
        })
    }

    /**
     * 清皮
     */
    fun clearTare() {
        if (tare + net == 0 && isScaleSuccess) {
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
            if (isScaleSuccess) {
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
            if (isScaleSuccess) {
                mScaleManager!!.tare()
                Toast.makeText(context, if (tare == 0) R.string.scale_more_peele else R.string.scale_more_clear_peele, Toast.LENGTH_LONG).show()
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
            if (isScaleSuccess) {
                mScaleManager!!.zero()
                Toast.makeText(context, R.string.scale_more_clear, Toast.LENGTH_LONG).show()
            }
        } catch (e: RemoteException) {
            e.printStackTrace()
        }
    }
}