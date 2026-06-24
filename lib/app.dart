import 'package:flutter/material.dart';
import 'package:orientate/core/routes/AppRoutes.dart';
import 'package:orientate/core/routes/RouteGenerator.dart';
import 'package:orientate/shared/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oriéntate+',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash.path,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
