import 'package:flutter/material.dart';
import 'package:mentorkhoj/utill/app_constants.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF0D47A1), // A deep blue as the primary color
  secondaryHeaderColor: const Color(0xFFBBDEFB), // Light blue as secondary
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFF82B1FF), // Lighter blue for focus
  hintColor: const Color(0xFF1565C0), // Medium blue for hints
  canvasColor: const Color(0xFFE3F2FD), // Very light blue for canvas
  shadowColor: Colors.blue[200], // Light blue shadows

  textTheme: const TextTheme(titleLarge: TextStyle(color: Color(0xFFE0E0E0))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  colorScheme: ColorScheme(
    background: const Color(0xFFE3F2FD), // Light blue background
    brightness: Brightness.light,
    primary: const Color(0xFF0D47A1), // Deep blue primary
    onPrimary: const Color(0xFFBBDEFB), // Light blue for onPrimary
    secondary: const Color(0xFF1565C0), // Another shade of blue for secondary
    onSecondary: const Color(0xFF82B1FF), // Lighter blue for onSecondary
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onBackground: const Color(0xFF90CAF9), // Lighter blue for onBackground
    surface: Colors.white,
    onSurface: const Color(0xFF1565C0), // Blue shade for onSurface
    shadow: Colors.blue[200], // Blue shadow
  ),
);
