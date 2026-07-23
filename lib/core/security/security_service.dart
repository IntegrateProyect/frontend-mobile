import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('orientate/security');

  static Future<bool> isSecureEnvironment() async {
    if (kDebugMode) {
      return true;
    }

    try {
      final bool adbEnabled =
          await _channel.invokeMethod<bool>('isAdbEnabled') ?? false;

      final bool emulator =
          await _channel.invokeMethod<bool>('isEmulator') ?? false;

      final bool rooted =
          await _channel.invokeMethod<bool>('isRooted') ?? false;
          
      final bool mockLocation =
          await _channel.invokeMethod<bool>('isMockLocationEnabled') ?? false;

      if (adbEnabled || emulator || rooted || mockLocation) {
        return false; // Entorno no seguro (dispositivo real comprometido en producción)
      }

      return true;
    } catch (_) {
      return true;
    }
  }
  
  static Future<bool> isAdbEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isAdbEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isMockLocationEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isMockLocationEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }
}
