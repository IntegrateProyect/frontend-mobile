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

      // Solo bloqueamos si el dispositivo está explícitamente rooteado/jailbroken.
      // Desactivamos la restricción de ADB (depuración USB) y emulador para permitir pruebas internas.
      if (rooted) {
        return false;
      }

      return true;
    } catch (_) {
      // Si el canal nativo no está implementado (MissingPluginException), permitimos continuar.
      return true;
    }
  }
}