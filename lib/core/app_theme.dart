import 'package:flutter/material.dart';

class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({required this.background});

  final LinearGradient background;

  @override
  AppGradients copyWith({LinearGradient? background}) =>
      AppGradients(background: background ?? this.background);

  @override
  AppGradients lerp(AppGradients? other, double t) => this;
}

class AppTheme {
  AppTheme._();

  // Light colors
  static const Color primaryColor = Color(0xFFE28C71);
  static const Color lightBackgroundColor = Color(0xFFF7F6F4);
  static const Color lightBackgroundGradientEnd = Color(0xFFEBDDD4);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF333333);
  static const Color lightSecondaryTextColor = Color(0xFF888888);
  static const Color lightCardShadowColor = Color(0x1A000000);
  static const Color errorColor = Colors.red;
  static const Color lightSegmentedControlColor = Color(0xFFECEBE9);
  static const Color lightSegmentedPillColor = lightCardColor;

  // Dark colors
  static const Color darkBackgroundColor = Color(0xFF0F0F0F);
  static const Color darkBackgroundGradientEnd = Color(0xFF1A1312);
  static const Color darkCardColor = Color(0xFF1A1A1A);
  static const Color darkTextColor = Color(0xFFF5F5F5);
  static const Color darkSecondaryTextColor = Color(0xFF8E8E93);
  static const Color darkCardShadowColor = Color(0x40000000);
  static const Color darkSegmentedControlColor = Color(0xFF2A2A2A);
  static const Color darkSegmentedPillColor = Color(0xFF3C3C3C);

  static const TextStyle headlineLargeText = TextStyle(
    color: lightTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineText = TextStyle(
    color: lightTextColor,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'Playfair',
  );

  static const TextStyle bodyLargeText = TextStyle(
    color: lightTextColor,
    fontSize: 15,
  );

  static const TextStyle bodyMediumText = TextStyle(
    color: lightTextColor,
    fontSize: 14,
  );

  static const TextStyle bodySmallText = TextStyle(
    color: lightSecondaryTextColor,
    fontSize: 12,
  );

  static const TextTheme lightTextTheme = TextTheme(
    headlineLarge: headlineLargeText,
    headlineMedium: headlineText,
    bodyLarge: bodyLargeText,
    bodyMedium: bodyMediumText,
    bodySmall: bodySmallText,
    titleMedium: bodyLargeText,
  );

  static const TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      color: darkTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: darkTextColor,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: 'Playfair',
    ),
    bodyLarge: TextStyle(color: darkTextColor, fontSize: 15),
    bodyMedium: TextStyle(color: darkTextColor, fontSize: 14),
    bodySmall: TextStyle(color: darkSecondaryTextColor, fontSize: 12),
    titleMedium: TextStyle(color: darkTextColor, fontSize: 15),
  );

  static const CardThemeData lightCardTheme = CardThemeData(
    color: lightCardColor,
    elevation: 2,
    shadowColor: lightCardShadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  static const CardThemeData darkCardTheme = CardThemeData(
    color: darkCardColor,
    elevation: 2,
    shadowColor: darkCardShadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  static final ChipThemeData lightChipTheme = ChipThemeData(
    color: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? primaryColor : lightCardColor,
    ),
    labelStyle: bodyMediumText.copyWith(color: lightTextColor),
    secondaryLabelStyle: bodyMediumText.copyWith(color: lightCardColor),
    showCheckmark: false,
    side: WidgetStateBorderSide.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? BorderSide.none
          : BorderSide(color: lightTextColor.withValues(alpha: 0.08)),
    ),
    shape: const StadiumBorder(),
  );

  static final ChipThemeData darkChipTheme = ChipThemeData(
    color: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? primaryColor : darkCardColor,
    ),
    labelStyle: const TextStyle(color: darkTextColor, fontSize: 14),
    secondaryLabelStyle: const TextStyle(color: darkTextColor, fontSize: 14),
    showCheckmark: false,
    side: WidgetStateBorderSide.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? BorderSide.none
          : const BorderSide(color: Color(0x1AF5F5F5)),
    ),
    shape: const StadiumBorder(),
  );

  static const ProgressIndicatorThemeData lightProgressIndicatorTheme =
      ProgressIndicatorThemeData(color: primaryColor);

  static const ProgressIndicatorThemeData darkProgressIndicatorTheme =
      ProgressIndicatorThemeData(color: primaryColor);

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      surface: lightBackgroundColor,
      onSurface: lightTextColor,
      surfaceContainerHighest: lightSegmentedControlColor,
      surfaceContainerHigh: lightSegmentedPillColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: lightTextTheme,
    cardTheme: lightCardTheme,
    chipTheme: lightChipTheme,
    progressIndicatorTheme: lightProgressIndicatorTheme,
    extensions: [
      AppGradients(
        background: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightBackgroundColor, lightBackgroundGradientEnd],
        ),
      ),
    ],
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: darkBackgroundColor,
      onSurface: darkTextColor,
      surfaceContainerHighest: darkSegmentedControlColor,
      surfaceContainerHigh: darkSegmentedPillColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: darkTextTheme,
    cardTheme: darkCardTheme,
    chipTheme: darkChipTheme,
    progressIndicatorTheme: darkProgressIndicatorTheme,
    extensions: [
      AppGradients(
        background: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkBackgroundColor, darkBackgroundGradientEnd],
        ),
      ),
    ],
  );
}
