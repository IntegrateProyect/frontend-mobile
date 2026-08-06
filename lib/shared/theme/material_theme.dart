import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff005bb2),
      surfaceTint: Color(0xff005db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2874d2),
      onPrimaryContainer: Color(0xfffefcff),
      secondary: Color(0xff495f84),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbcd2fd),
      onSecondaryContainer: Color(0xff455a7f),
      tertiary: Color(0xff863d9a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa156b5),
      onTertiaryContainer: Color(0xfffffbff),
      error: Color(0xffb41c1b),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffd83831),
      onErrorContainer: Color(0xfffffbff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191c22),
      onSurfaceVariant: Color(0xff414752),
      outline: Color(0xff727784),
      outlineVariant: Color(0xffc1c6d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3d),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff00468b),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff001b3d),
      secondaryFixedDim: Color(0xffb1c7f2),
      onSecondaryFixedVariant: Color(0xff31476b),
      tertiaryFixed: Color(0xfffbd7ff),
      onTertiaryFixed: Color(0xff340043),
      tertiaryFixedDim: Color(0xfff2afff),
      onTertiaryFixedVariant: Color(0xff6e2583),
      surfaceDim: Color(0xffd8dae2),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fc),
      surfaceContainer: Color(0xffecedf6),
      surfaceContainerHigh: Color(0xffe6e8f0),
      surfaceContainerHighest: Color(0xffe1e2ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00356d),
      surfaceTint: Color(0xff005db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1b6cca),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff203659),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff586e94),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5b0e71),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff994ead),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcd302a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0e1117),
      onSurfaceVariant: Color(0xff313641),
      outline: Color(0xff4d535e),
      outlineVariant: Color(0xff686d79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xff1b6cca),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0054a5),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff586e94),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff40557a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff994ead),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7d3592),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6ce),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fc),
      surfaceContainer: Color(0xffe6e8f0),
      surfaceContainerHigh: Color(0xffdbdce5),
      surfaceContainerHighest: Color(0xffd0d1d9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002c5b),
      surfaceTint: Color(0xff005db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004890),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff142c4e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff344a6d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4e0063),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff702886),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272c37),
      outlineVariant: Color(0xff444955),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffa9c7ff),
      primaryFixed: Color(0xff004890),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003267),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff344a6d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1c3355),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff702886),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff56076d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb7b8c0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff0f9),
      surfaceContainer: Color(0xffe1e2ea),
      surfaceContainerHigh: Color(0xffd3d4dc),
      surfaceContainerHighest: Color(0xffc5c6ce),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa9c7ff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff003063),
      primaryContainer: Color(0xff4e91f1),
      onPrimaryContainer: Color(0xff001633),
      secondary: Color(0xffb1c7f2),
      onSecondary: Color(0xff193053),
      secondaryContainer: Color(0xff31476b),
      onSecondaryContainer: Color(0xffa0b6e0),
      tertiary: Color(0xfff2afff),
      onTertiary: Color(0xff54036a),
      tertiaryContainer: Color(0xffc072d4),
      onTertiaryContainer: Color(0xff2b0038),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff5c0004),
      surface: Color(0xff111319),
      onSurface: Color(0xffe1e2ea),
      onSurfaceVariant: Color(0xffc1c6d4),
      outline: Color(0xff8b919e),
      outlineVariant: Color(0xff414752),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff005db6),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3d),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff00468b),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff001b3d),
      secondaryFixedDim: Color(0xffb1c7f2),
      onSecondaryFixedVariant: Color(0xff31476b),
      tertiaryFixed: Color(0xfffbd7ff),
      onTertiaryFixed: Color(0xff340043),
      tertiaryFixedDim: Color(0xfff2afff),
      onTertiaryFixedVariant: Color(0xff6e2583),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff363940),
      surfaceContainerLowest: Color(0xff0b0e14),
      surfaceContainerLow: Color(0xff191c22),
      surfaceContainer: Color(0xff1d2026),
      surfaceContainerHigh: Color(0xff272a30),
      surfaceContainerHighest: Color(0xff32353b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffccddff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff00254f),
      primaryContainer: Color(0xff4e91f1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffccddff),
      onSecondary: Color(0xff0c2647),
      secondaryContainer: Color(0xff7c91b9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff9ceff),
      onTertiary: Color(0xff440057),
      tertiaryContainer: Color(0xffc072d4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dcea),
      outline: Color(0xffadb2bf),
      outlineVariant: Color(0xff8b909d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff00478d),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff00112a),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff00356d),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff00112a),
      secondaryFixedDim: Color(0xffb1c7f2),
      onSecondaryFixedVariant: Color(0xff203659),
      tertiaryFixed: Color(0xfffbd7ff),
      onTertiaryFixed: Color(0xff23002f),
      tertiaryFixedDim: Color(0xfff2afff),
      onTertiaryFixedVariant: Color(0xff5b0e71),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff42444b),
      surfaceContainerLowest: Color(0xff05070d),
      surfaceContainerLow: Color(0xff1b1e24),
      surfaceContainer: Color(0xff25282e),
      surfaceContainerHigh: Color(0xff303339),
      surfaceContainerHighest: Color(0xff3b3e44),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffa9c7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa2c4ff),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffebf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffadc3ee),
      onSecondaryContainer: Color(0xff000b20),
      tertiary: Color(0xffffeafe),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff0a9ff),
      onTertiaryContainer: Color(0xff1a0023),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea5),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf0fe),
      outlineVariant: Color(0xffbec2d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff00478d),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa9c7ff),
      onPrimaryFixedVariant: Color(0xff00112a),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb1c7f2),
      onSecondaryFixedVariant: Color(0xff00112a),
      tertiaryFixed: Color(0xfffbd7ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff2afff),
      onTertiaryFixedVariant: Color(0xff23002f),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff4d5057),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2026),
      surfaceContainer: Color(0xff2e3037),
      surfaceContainerHigh: Color(0xff393b42),
      surfaceContainerHighest: Color(0xff44474d),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
  );

  /// Success
  static const success = ExtendedColor(
    seed: Color(0xff2e7d32),
    value: Color(0xff2e7d32),
    light: ColorFamily(
      color: Color(0xff0d631b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff0d631b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff0d631b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
    dark: ColorFamily(
      color: Color(0xff88d982),
      onColor: Color(0xff003909),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff88d982),
      onColor: Color(0xff003909),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff88d982),
      onColor: Color(0xff003909),
      colorContainer: Color(0xff2e7d32),
      onColorContainer: Color(0xffcbffc2),
    ),
  );

  /// Warning
  static const warning = ExtendedColor(
    seed: Color(0xffed6c02),
    value: Color(0xffed6c02),
    light: ColorFamily(
      color: Color(0xff9c4400),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff9c4400),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff9c4400),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
    dark: ColorFamily(
      color: Color(0xffffb68e),
      onColor: Color(0xff542200),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb68e),
      onColor: Color(0xff542200),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb68e),
      onColor: Color(0xff542200),
      colorContainer: Color(0xffed6c02),
      onColorContainer: Color(0xff4b1d00),
    ),
  );

  /// Info
  static const info = ExtendedColor(
    seed: Color(0xff0288d1),
    value: Color(0xff0288d1),
    light: ColorFamily(
      color: Color(0xff006096),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff007abc),
      onColorContainer: Color(0xfffdfcff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006096),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff007abc),
      onColorContainer: Color(0xfffdfcff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006096),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff007abc),
      onColorContainer: Color(0xfffdfcff),
    ),
    dark: ColorFamily(
      color: Color(0xff96ccff),
      onColor: Color(0xff003353),
      colorContainer: Color(0xff2b97e1),
      onColorContainer: Color(0xff001b2f),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff96ccff),
      onColor: Color(0xff003353),
      colorContainer: Color(0xff2b97e1),
      onColorContainer: Color(0xff001b2f),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff96ccff),
      onColor: Color(0xff003353),
      colorContainer: Color(0xff2b97e1),
      onColorContainer: Color(0xff001b2f),
    ),
  );

  /// Recommendation
  static const recommendation = ExtendedColor(
    seed: Color(0xff6d4cbe),
    value: Color(0xff6d4cbe),
    light: ColorFamily(
      color: Color(0xff5532a4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff5532a4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff5532a4),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
    dark: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3a0c8a),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3a0c8a),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffd0bcff),
      onColor: Color(0xff3a0c8a),
      colorContainer: Color(0xff6d4cbe),
      onColorContainer: Color(0xffe5d8ff),
    ),
  );

  /// Favorite
  static const favorite = ExtendedColor(
    seed: Color(0xffc2185b),
    value: Color(0xffc2185b),
    light: ColorFamily(
      color: Color(0xff9b0044),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff9b0044),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff9b0044),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
    dark: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb1c2),
      onColor: Color(0xff66002b),
      colorContainer: Color(0xffc2185b),
      onColorContainer: Color(0xffffd9df),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    success,
    warning,
    info,
    recommendation,
    favorite,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
