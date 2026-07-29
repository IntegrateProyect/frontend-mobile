import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/routes/app_router.dart';
import 'shared/theme/theme.dart';
import 'shared/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Oriéntate+',

          // Temas de la aplicación
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,

          // GoRouter
          routerConfig: appRouter,

          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            final double textScale = mediaQuery.textScaler
                .scale(1.0)
                .clamp(0.85, 1.20)
                .toDouble();

            final clampedMediaQuery = mediaQuery.copyWith(
              textScaler: TextScaler.linear(textScale),
            );

            return MediaQuery(
              data: clampedMediaQuery,
              child: ResponsiveBreakpoints.builder(
                child: child ?? const SizedBox.shrink(),
                breakpoints: const [
                  Breakpoint(
                    start: 0,
                    end: 450,
                    name: MOBILE,
                  ),
                  Breakpoint(
                    start: 451,
                    end: 800,
                    name: TABLET,
                  ),
                  Breakpoint(
                    start: 801,
                    end: 1920,
                    name: DESKTOP,
                  ),
                  Breakpoint(
                    start: 1921,
                    end: double.infinity,
                    name: '4K',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}