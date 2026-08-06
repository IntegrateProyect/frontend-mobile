import 'package:flutter/material.dart';

enum AppScreenSize { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  AppScreenSize get screenSize {
    final double width = MediaQuery.of(this).size.width;
    if (width < 600) return AppScreenSize.mobile;
    if (width < 1024) return AppScreenSize.tablet;
    return AppScreenSize.desktop;
  }

  bool get isMobile => screenSize == AppScreenSize.mobile;
  bool get isTablet => screenSize == AppScreenSize.tablet;
  bool get isDesktop => screenSize == AppScreenSize.desktop;

  // Helper para valores basados en el tamaño de pantalla
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final size = screenSize;
    switch (size) {
      case AppScreenSize.mobile:
        return mobile;
      case AppScreenSize.tablet:
        return tablet ?? mobile;
      case AppScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
