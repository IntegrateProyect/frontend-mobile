import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentinel_ai/src/di/injection.dart';
import 'app.dart';

void main() async {
  // ← agrega async
  WidgetsFlutterBinding.ensureInitialized(); // ← necesario antes de cualquier setup
  await dotenv.load(fileName: '.env'); // ← carga variables de entorno
  setupInjection(); // ← registra todos los servicios en GetIt
  runApp(DevicePreview(enabled: kIsWeb, builder: (context) => const MyApp()));
}
