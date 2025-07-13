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
    when (call.method) {
        "getRingtones" -> {
            getRingtones(result)
        }
        "getRingtonesByType" -> {
            val type = call.argument<Int>("type") ?: RingtoneManager.TYPE_RINGTONE
            getRingtonesByType(type, result)
        }
        "getRingtonesByTypes" -> {
            val types = call.argument<List<Int>>("types") ?: listOf(RingtoneManager.TYPE_RINGTONE)
            getRingtonesByTypes(types, result)
        }
        "getRingtonesWithFilter" -> {
            val includeRingtone = call.argument<Boolean>("includeRingtone") ?: false
            val includeNotification = call.argument<Boolean>("includeNotification") ?: false
            val includeAlarm = call.argument<Boolean>("includeAlarm") ?: false
            getRingtonesWithFilter(includeRingtone, includeNotification, includeAlarm, result)
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
        ringtone.put("type", RingtoneManager.TYPE_RINGTONE)

        ringtones.put(ringtone)
      }

      cursor.close()
      result.success(ringtones.toString())
    } catch (e : Exception) {
      result.error("RINGTONE_ERROR", "Failed to get ringtones", e.message)
    }
  }

  private fun getRingtonesByType(type: Int, result: Result) {
    try {
      val ringtoneManager = RingtoneManager(context)
      ringtoneManager.setType(type)
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
        ringtone.put("type", type)

        ringtones.put(ringtone)
      }

      cursor.close()
      result.success(ringtones.toString())
    } catch (e : Exception) {
      result.error("RINGTONE_ERROR", "Failed to get ringtones by type", e.message)
    }
  }

  private fun getRingtonesByTypes(types: List<Int>, result: Result) {
    try {
      val allRingtones = JSONArray()
      
      for (type in types) {
        val ringtoneManager = RingtoneManager(context)
        ringtoneManager.setType(type)
        val cursor = ringtoneManager.cursor

        while (cursor.moveToNext()) {
          val ringtone = JSONObject()
          val id = cursor.getLong(RingtoneManager.ID_COLUMN_INDEX)
          val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
          val uri = ringtoneManager.getRingtoneUri(cursor.position)

          ringtone.put("id", id)
          ringtone.put("title", title)
          ringtone.put("uri", uri.toString())
          ringtone.put("type", type)

          allRingtones.put(ringtone)
        }

        cursor.close()
      }

      result.success(allRingtones.toString())
    } catch (e : Exception) {
      result.error("RINGTONE_ERROR", "Failed to get ringtones by types", e.message)
    }
  }

  private fun getRingtonesWithFilter(includeRingtone: Boolean, includeNotification: Boolean, includeAlarm: Boolean, result: Result) {
    try {
      val types = mutableListOf<Int>()
      
      if (includeRingtone) types.add(RingtoneManager.TYPE_RINGTONE)
      if (includeNotification) types.add(RingtoneManager.TYPE_NOTIFICATION)
      if (includeAlarm) types.add(RingtoneManager.TYPE_ALARM)
      
      if (types.isEmpty()) {
        // Default to ringtone if no types specified
        types.add(RingtoneManager.TYPE_RINGTONE)
      }

      getRingtonesByTypes(types, result)
    } catch (e : Exception) {
      result.error("RINGTONE_ERROR", "Failed to get ringtones with filter", e.message)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
