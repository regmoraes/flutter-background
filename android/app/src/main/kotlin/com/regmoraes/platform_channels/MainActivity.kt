package com.regmoraes.platform_channels

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import androidx.work.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "com.regmoraes.platformchannels/background"
        ).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

        val backgroundWork: WorkRequest = OneTimeWorkRequestBuilder<BackgroundWork>()
                .setConstraints(constraints)
                .build()

        when (call.method) {
            "initialize" -> {
                val callbackHandleId = call.arguments as Long

                getSharedPreferences("com.regmoraes.platformchannels", Context.MODE_PRIVATE)
                        .edit()
                        .putLong("CALLBACK_HANDLE_ID", callbackHandleId)
                        .apply()

                result.success(null)
            }
            "schedule" -> {
                WorkManager.getInstance(this).enqueue(backgroundWork)
                result.success(true)
            }
        }
    }
}
