package com.orientate.app.orientate

import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "orientate/security"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAdbEnabled" -> {
                    result.success(isAdbEnabled())
                }
                "isEmulator" -> {
                    result.success(isEmulator())
                }
                "isRooted" -> {
                    result.success(isRooted())
                }
                "isMockLocationEnabled" -> {
                    result.success(isMockLocationEnabled())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isAdbEnabled(): Boolean {
        return Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) > 0
    }

    private fun isEmulator(): Boolean {
        return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.FINGERPRINT.contains("generic")
                || Build.FINGERPRINT.contains("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_google")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator")
    }

    private fun isRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        return false
    }

    private fun isMockLocationEnabled(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // En versiones modernas, esto se maneja por App, 
                // pero Settings.Secure.ALLOW_MOCK_LOCATION ya no es confiable.
                // Se suele verificar si hay apps de mock instaladas o si la ubicación viene de mock
                // Para simplificar a nivel de settings (desarrollador):
                Settings.Secure.getString(contentResolver, Settings.Secure.ALLOW_MOCK_LOCATION) != "0"
            } else {
                Settings.Secure.getString(contentResolver, Settings.Secure.ALLOW_MOCK_LOCATION) != "0"
            }
        } catch (e: Exception) {
            false
        }
    }
}
