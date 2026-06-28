import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/routes/app_router.dart';
import 'shared/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicialización de ScreenUtil para adaptabilidad de fuentes y tamaños
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Tamaño base de diseño (iPhone X/11/12/13/14)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Oriéntate+',
          theme: AppTheme.lightTheme,
          
          // Configuración de GoRouter (Enrutado 2.0)
          routerConfig: appRouter,
          
          // Configuración de Responsive Framework para breakpoints profesionales
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
        );
      },
    );
  }
}
