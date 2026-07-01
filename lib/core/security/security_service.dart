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

      if (adbEnabled || emulator || rooted) {
        return false; // Entorno no seguro (dispositivo real comprometido en producción)
      }

      return true;
    } catch (_) {
      return true;
    }
  }
}