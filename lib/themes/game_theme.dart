import 'package:flutter/material.dart';

class GameTheme {
  // Define Game Boy-like colors
  static const Color backgroundColor =
      Color(0xFF0f380f); // Dark green background
  static const Color foregroundColor =
      Color(0xFF9bbc0f); // Light green foreground
  static const Color buttonColor = Color(0xFF306230); // Mid-tone for buttons
  static const Color accentColor = Color(0xFF8bac0f); // Accent elements

  // The ThemeData applies the styles globally
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(
        backgroundColor.value, // Creating a MaterialColor from backgroundColor
        const {
          50: backgroundColor,
          100: backgroundColor,
          200: backgroundColor,
          300: backgroundColor,
          400: backgroundColor,
          500: backgroundColor,
          600: backgroundColor,
          700: backgroundColor,
          800: backgroundColor,
          900: backgroundColor,
        },
      ),
    ).copyWith(
      secondary: accentColor,
      onSecondary:
          foregroundColor, // Text/icon color on top of accentColor elements
      onPrimary:
          foregroundColor, // Text/icon color on top of primaryColor elements
      background: backgroundColor,
      onBackground: foregroundColor, // Text/icon color on background
      surface: backgroundColor,
      onSurface: foregroundColor, // Text/icon color on card-like surfaces
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24.0,
        fontFamily: 'PressStart2P',
        color: foregroundColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 14.0,
        fontFamily: 'PressStart2P',
        color: foregroundColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontFamily: 'PressStart2P',
        color: foregroundColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: foregroundColor,
      size: 24.0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(0), // Game Boy buttons were typically square
      ),
      textTheme:
          ButtonTextTheme.primary, // Ensures button text uses the primary color
    ),
    // You may add additional theming here for other widgets like AppBar, etc.
  );
}
