package com.ahmetaliasik.jbh_ringtone

import android.content.Context
import android.media.RingtoneManager
import android.media.MediaPlayer
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/** JbhRingtonePlugin */
class JbhRingtonePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private var mediaPlayer: MediaPlayer? = null

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
        "getRingtoneDetails" -> {
            val uriString = call.argument<String>("uri")
            val uri = Uri.parse(uriString)
            getRingtoneDetails(uri, result)
        }
        "playRingtone" -> {
            val uriString = call.argument<String>("uri")
            val uri = Uri.parse(uriString)
            playRingtone(uri, result)
        }
        "stopRingtone" -> {
            stopRingtone(result)
        }
        "getRingtoneInfo" -> {
            val uriString = call.argument<String>("uri")
            val uri = Uri.parse(uriString)
            getRingtoneInfo(uri, result)
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
        val uri = ringtoneManager.getRingtoneUri(cursor.position)
        val cursorTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
        
        // Hızlı title alma - sadece gerekli olanı
        val title = getQuickTitle(uri, cursorTitle)

        ringtone.put("id", id)
        ringtone.put("title", title)
        ringtone.put("displayTitle", title)
        ringtone.put("fileName", uri.lastPathSegment ?: "unknown")
        ringtone.put("uri", uri.toString())
        ringtone.put("uriType", if (uri.scheme == "content") "content" else "file")
        ringtone.put("filePath", null) // Lazy loading için null
        ringtone.put("fileSize", 0) // Lazy loading için 0
        ringtone.put("duration", 0) // Lazy loading için 0
        ringtone.put("type", RingtoneManager.TYPE_RINGTONE)
        ringtone.put("isDefault", false) // Lazy loading için false

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
        val uri = ringtoneManager.getRingtoneUri(cursor.position)
        val cursorTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
        
        // Hızlı title alma - sadece gerekli olanı
        val title = getQuickTitle(uri, cursorTitle)

        ringtone.put("id", id)
        ringtone.put("title", title)
        ringtone.put("displayTitle", title)
        ringtone.put("fileName", uri.lastPathSegment ?: "unknown")
        ringtone.put("uri", uri.toString())
        ringtone.put("uriType", if (uri.scheme == "content") "content" else "file")
        ringtone.put("filePath", null) // Lazy loading için null
        ringtone.put("fileSize", 0) // Lazy loading için 0
        ringtone.put("duration", 0) // Lazy loading için 0
        ringtone.put("type", type)
        ringtone.put("isDefault", false) // Lazy loading için false

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
          val uri = ringtoneManager.getRingtoneUri(cursor.position)
          val cursorTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
          
          // Hızlı title alma - sadece gerekli olanı
          val title = getQuickTitle(uri, cursorTitle)

          ringtone.put("id", id)
          ringtone.put("title", title)
          ringtone.put("displayTitle", title)
          ringtone.put("fileName", uri.lastPathSegment ?: "unknown")
          ringtone.put("uri", uri.toString())
          ringtone.put("uriType", if (uri.scheme == "content") "content" else "file")
          ringtone.put("filePath", null) // Lazy loading için null
          ringtone.put("fileSize", 0) // Lazy loading için 0
          ringtone.put("duration", 0) // Lazy loading için 0
          ringtone.put("type", type)
          ringtone.put("isDefault", false) // Lazy loading için false

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

  private fun playRingtone(uri: Uri, result: Result) {
    try {
      // Önceki çalan sesi durdur
      stopRingtone(null)
      
      mediaPlayer = MediaPlayer().apply {
        setDataSource(context, uri)
        prepare()
        start()
      }
      
      result.success("Playing ringtone")
    } catch (e: Exception) {
      result.error("PLAY_ERROR", "Failed to play ringtone", e.message)
    }
  }

  private fun stopRingtone(result: Result?) {
    try {
      mediaPlayer?.apply {
        if (isPlaying) {
          stop()
        }
        release()
      }
      mediaPlayer = null
      result?.success("Stopped ringtone")
    } catch (e: Exception) {
      result?.error("STOP_ERROR", "Failed to stop ringtone", e.message)
    }
  }

  private fun getRingtoneInfo(uri: Uri, result: Result) {
    try {
      val ringtone = RingtoneManager.getRingtone(context, uri)
      val info = JSONObject().apply {
        put("title", ringtone?.getTitle(context) ?: "Unknown")
        put("uri", uri.toString())
        put("isPlaying", mediaPlayer?.isPlaying ?: false)
        put("duration", mediaPlayer?.duration ?: 0)
      }
      
      result.success(info.toString())
    } catch (e: Exception) {
      result.error("INFO_ERROR", "Failed to get ringtone info", e.message)
    }
  }

  private fun getRingtoneDetails(uri: Uri, result: Result) {
    try {
      val details = JSONObject()
      
      // Gelişmiş title alma
      val titleInfo = getEnhancedTitle(uri, null)
      
      // URI bilgilerini geliştir
      val uriInfo = getUriInfo(uri)
      
      // Default ringtone kontrolü
      val isDefault = isDefaultRingtone(uri)

      details.put("title", titleInfo.title)
      details.put("displayTitle", titleInfo.displayTitle)
      details.put("fileName", titleInfo.fileName)
      details.put("uriType", uriInfo.type)
      details.put("filePath", uriInfo.filePath)
      details.put("fileSize", uriInfo.fileSize)
      details.put("duration", uriInfo.duration)
      details.put("isDefault", isDefault)

      result.success(details.toString())
    } catch (e: Exception) {
      result.error("DETAILS_ERROR", "Failed to get ringtone details", e.message)
    }
  }

  data class TitleInfo(
      val title: String,
      val displayTitle: String,
      val fileName: String
  )

  data class UriInfo(
      val type: String,
      val filePath: String?,
      val fileSize: Long,
      val duration: Int
  )

  private fun getEnhancedTitle(uri: Uri, cursor: android.database.Cursor?): TitleInfo {
      val cursorTitle = cursor?.getString(RingtoneManager.TITLE_COLUMN_INDEX)
      
      // Ringtone nesnesinden gerçek ismi al
      val actualTitle = try {
          val ringtone = RingtoneManager.getRingtone(context, uri)
          ringtone?.getTitle(context)
      } catch (e: Exception) {
          null
      }
      
      // Dosya adını al
      val fileName = try {
          val file = File(uri.path ?: "")
          file.nameWithoutExtension
      } catch (e: Exception) {
          uri.lastPathSegment ?: "unknown"
      }
      
      // En iyi title'ı seç
      val finalTitle = when {
          !actualTitle.isNullOrEmpty() && !actualTitle.startsWith("ringtone_") -> actualTitle
          !cursorTitle.isNullOrEmpty() && !cursorTitle.startsWith("ringtone_") -> cursorTitle
          else -> fileName
      }
      
      // Display title oluştur (kullanıcı dostu)
      val displayTitle = when {
          finalTitle.startsWith("ringtone_") -> fileName
          finalTitle.length > 30 -> finalTitle.substring(0, 27) + "..."
          else -> finalTitle
      }
      
      return TitleInfo(
          title = finalTitle,
          displayTitle = displayTitle,
          fileName = fileName
      )
  }

  private fun getUriInfo(uri: Uri): UriInfo {
      var filePath: String? = null
      var fileSize: Long = 0
      var duration: Int = 0
      
      try {
          // Content URI'den dosya bilgilerini al
          val cursor = context.contentResolver.query(
              uri,
              arrayOf(
                  MediaStore.Audio.Media.DATA,
                  MediaStore.Audio.Media.SIZE,
                  MediaStore.Audio.Media.DURATION
              ),
              null,
              null,
              null
          )
          
          cursor?.use {
              if (it.moveToFirst()) {
                  filePath = it.getString(it.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA))
                  fileSize = it.getLong(it.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE))
                  duration = it.getInt(it.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION))
              }
          }
      } catch (e: Exception) {
          // Hata durumunda varsayılan değerler
      }
      
      val uriType = when {
          uri.scheme == "content" -> "content"
          uri.scheme == "file" -> "file"
          else -> "unknown"
      }
      
      return UriInfo(uriType, filePath, fileSize, duration)
  }

  private fun isDefaultRingtone(uri: Uri): Boolean {
      return try {
          RingtoneManager.isDefault(uri)
      } catch (e: Exception) {
          false
      }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    stopRingtone(null)
  }

  // Hızlı title alma fonksiyonu
  private fun getQuickTitle(uri: Uri, cursorTitle: String): String {
    // Önce cursor'dan gelen title'ı kontrol et
    if (!cursorTitle.isNullOrEmpty() && !cursorTitle.startsWith("ringtone_")) {
      return cursorTitle
    }
    
    // Eğer cursor title uygun değilse, URI'den dosya adını al
    val fileName = uri.lastPathSegment ?: "unknown"
    return if (fileName.startsWith("ringtone_")) {
      // Dosya adından uzantıyı çıkar
      fileName.substringBeforeLast(".").substringBeforeLast("_")
    } else {
      fileName.substringBeforeLast(".")
    }
  }
}
