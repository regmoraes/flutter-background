package com.regmoraes.platform_channels

import android.content.Context
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import io.flutter.view.FlutterMain.startInitialization
import io.flutter.view.FlutterNativeView
import io.flutter.view.FlutterRunArguments
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlin.random.Random


class BackgroundWork(private val context: Context, workerParams: WorkerParameters) : CoroutineWorker(context, workerParams) {

    companion object {
        @JvmStatic
        private var backgroundFlutterEngine: FlutterEngine? = null
    }

    override suspend fun doWork(): Result {
        return withContext(Dispatchers.Main) {
            val callbackHandleId = context.getSharedPreferences(
                    "com.regmoraes.platformchannels", Context.MODE_PRIVATE
            ).getLong("CALLBACK_HANDLE_ID", 0L)

            val flutterCallbackInformation = FlutterCallbackInformation.lookupCallbackInformation(callbackHandleId)

            val flutterRunArguments = FlutterRunArguments()
            flutterRunArguments.bundlePath = FlutterMain.findAppBundlePath()
            flutterRunArguments.entrypoint = flutterCallbackInformation.callbackName
            flutterRunArguments.libraryPath = flutterCallbackInformation.callbackLibraryPath

            FlutterInjector
                    .instance()
                    .flutterLoader()
                    .startInitialization(context)

            val backgroundFlutterView = FlutterNativeView(context, true)

            backgroundFlutterView.runFromBundle(flutterRunArguments)

            val backgroundChannel = MethodChannel(backgroundFlutterView, "background_channel")

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentTitle("Background Work Executed")
                    .setContentText("Uhul!")
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .build()

            with(NotificationManagerCompat.from(context)) {
                notify(Random(0).nextInt(), notification)
            }

            backgroundChannel.invokeMethod("finishedWork", null)

            Result.success()
        }
    }
}
