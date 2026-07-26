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

          // =========================================================
          // FIX: limitar el textScaler del sistema.
          //
          // Sin este límite, si el usuario tiene "Tamaño de fuente"
          // al máximo en los ajustes de accesibilidad del teléfono,
          // ese factor de escala se multiplica sin techo sobre TODOS
          // los tamaños .sp de flutter_screenutil, provocando que el
          // texto crezca tanto que ni una sola letra cabe en el ancho
          // disponible (cada carácter termina en su propia línea,
          // como en "Mis grupos" / "Agenda").
          //
          // clamp(0.85, 1.2) respeta la preferencia de accesibilidad
          // del usuario (permite un poco más grande o más chico) pero
          // le pone un límite razonable para no romper el layout.
          // =========================================================
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            final clampedMediaQuery = mediaQuery.copyWith(
              textScaler: TextScaler.linear(
                mediaQuery.textScaler.scale(1.0).clamp(0.85, 1.2),
              ),
            );

            return MediaQuery(
              data: clampedMediaQuery,
              child: ResponsiveBreakpoints.builder(
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
      },
    );
  }
}