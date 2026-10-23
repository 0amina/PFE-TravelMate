import 'package:flutter/material.dart';


class MyTheme {
  MyTheme._();

  // Light color scheme
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 255, 146, 99),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color.fromARGB(255, 255, 146, 99),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFCFDF6),
    onBackground: Color(0xFF1A1C18),
    shadow: Color(0xFF000000),
    outlineVariant: Color(0xFFC2C8BC),
    surface: Color(0xFFF9FAF3),
    onSurface: Color(0xFF1A1C18),
  );

  // Dark color scheme
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9363),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF6EAEE7),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFCFDF6),
    onBackground: Color(0xFF1A1C18),
    shadow: Color(0xFF000000),
    outlineVariant: Color(0xFFC2C8BC),
    surface: Color(0xFFF9FAF3),
    onSurface: Color(0xFF1A1C18),
  );

  // Light mode theme
  static ThemeData lightMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          lightColorScheme.primary,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(5.0),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ),
  );

  // Dark mode theme
  static ThemeData darkMode = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
  );

  // Colors
  static const Color kPrimaryColor = Color.fromRGBO(255, 190, 146, 0.616);
  static const Color kPrimaryColorVariant = Color.fromRGBO(244, 148, 92, 0.616);
  static const Color kAccentColor = Color.fromARGB(255, 227, 220, 220);
  static const Color kAccentColorVariant = Color.fromARGB(255, 227, 220, 220);

  // Text styles
  static const TextStyle heading2 = TextStyle(
    color: Color.fromRGBO(0, 193, 250, 1),
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static const TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle bodyText1 = TextStyle(
    color: Color.fromRGBO(0, 193, 250, 1),
    fontSize: 14,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyTextMessage = TextStyle(
    fontSize: 13,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyTextTime = TextStyle(
    color: Color.fromRGBO(0, 193, 250, 1),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
