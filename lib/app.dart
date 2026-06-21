// lib/app.dart
import 'package:clases/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'src/shared/theme/theme.dart';
import 'src/shared/theme/util.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, 'ABeeZee', 'Roboto');
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Sentinel AI',
      theme: brightness == Brightness.light
          ? materialTheme.light()
          : materialTheme.dark(),
      initialRoute: '/profile',
      routes: AppRouter.routes, // ← limpio, todo centralizado
    );
  }
}