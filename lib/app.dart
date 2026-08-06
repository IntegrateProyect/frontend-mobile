import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orientate/shared/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/routes/app_router.dart';
import 'shared/theme/material_theme.dart';
import 'shared/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Oriéntate+',

      // DevicePreview: locale del dispositivo simulado
      locale: DevicePreview.locale(context),

      // Configuración de temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Enrutador GoRouter
      routerConfig: appRouter,

      builder: (context, child) {
        // appBuilder debe ser el wrapper más externo para que el MediaQuery
        // simulado del dispositivo se aplique sobre el contenido responsive actual.
        return DevicePreview.appBuilder(
          context,
          _buildResponsiveContent(context, child),
        );
      },
    );
  }

  Widget _buildResponsiveContent(BuildContext context, Widget? child) {
    final mediaQuery = MediaQuery.of(context);

    // Controlamos el factor de escala del texto
    final double textScale = mediaQuery.textScaler
        .scale(1.0)
        .clamp(0.85, 1.15)
        .toDouble();

    final clampedMediaQuery = mediaQuery.copyWith(
      textScaler: TextScaler.linear(textScale),
    );

    return MediaQuery(
      data: clampedMediaQuery,
      child: ResponsiveBreakpoints.builder(
        child: Builder(
          builder: (context) {
            // El ResponsiveScaledBox escala proporcionalmente el contenido
            // basándose en el ancho de diseño según el dispositivo.
            final double? scaledWidth = ResponsiveValue<double?>(
              context,
              conditionalValues: [
                const Condition.equals(name: MOBILE, value: 375),
                const Condition.equals(name: TABLET, value: 800),
                const Condition.equals(name: DESKTOP, value: 1200),
              ],
            ).value;

            return ResponsiveScaledBox(
              width: scaledWidth,
              child: Builder(
                builder: (context) {
                  // Configuración global y reactiva de ScreenUtil
                  ScreenUtil.configure(
                    data: MediaQuery.of(context),
                    designSize: const Size(375, 812),
                    minTextAdapt: true,
                    splitScreenMode: true,
                  );
                  return child ?? const SizedBox.shrink();
                },
              ),
            );
          },
        ),
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
