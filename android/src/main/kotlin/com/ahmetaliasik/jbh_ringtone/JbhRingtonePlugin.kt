package com.ahmetaliasik.jbh_ringtone

import android.content.Context
import android.media.RingtoneManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject

/** JbhRingtonePlugin */
class JbhRingtonePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "jbh_ringtone")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) { // 'metod' değil, 'method' olmalı
        "getRingtones" -> {
            getRingtones(result)
        }
        "getPlatformVersion" -> {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        else -> {
            result.notImplemented()
        }
    }
  }

  private fun getRingtones(result : Result ) {
    try {
      val ringtoneManager = RingtoneManager(context)
      ringtoneManager.setType(RingtoneManager.TYPE_RINGTONE)
      val cursor = ringtoneManager.cursor

      val ringtones = JSONArray()

      while (cursor.moveToNext()) {
        val ringtone = JSONObject()
        val id = cursor.getLong(RingtoneManager.ID_COLUMN_INDEX)
        val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)

        val uri = ringtoneManager.getRingtoneUri(cursor.position)

        ringtone.put("id", id)
        ringtone.put("title", title)
        ringtone.put("uri", uri.toString())

        ringtones.put(ringtone)
      }

      cursor.close()
      result.success(ringtones.toString())
    } catch (e : Exception) {
      result.error("RINGTONE_ERROR", "Failed to get ringtones", e.message)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
