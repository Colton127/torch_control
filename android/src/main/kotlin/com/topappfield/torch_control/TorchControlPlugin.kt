package com.topappfield.torch_control

import android.content.Context
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class TorchControlPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private var torchControl: TorchControl? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "torch_control")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        if (torchControl != null) torchControl?.release()
        torchControl = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "turn" -> {
                val state: Boolean = call.argument<Boolean>("state") ?: false
                result.success( getTorchControl().turn(state) )
            }
            "ready" -> {
                result.success( getTorchControl().ready() )
            }
            "deviceLock" -> {
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    fun getTorchControl(): TorchControl {
        if (torchControl == null) {
            torchControl =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) TorchControlB(context)
                else TorchControlA(context)
        }
        return torchControl as TorchControl
    }

}
