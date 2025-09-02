import 'package:flutter/material.dart';
import 'package:wedding_planner/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFE91E63, {
          50: Color(0xFFFCE4EC),
          100: Color(0xFFF8BBD9),
          200: Color(0xFFF48FB1),
          300: Color(0xFFF06292),
          400: Color(0xFFEC407A),
          500: Color(0xFFE91E63),
          600: Color(0xFFD81B60),
          700: Color(0xFFC2185B),
          800: Color(0xFFAD1457),
          900: Color(0xFF880E4F),
        }),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: Color(0xFFE91E63),
              brightness: Brightness.light,
            ).copyWith(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              secondary: Color(0xFFFF6F91),
              onSecondary: Colors.white,
              surface: Color(0xFFFFFBFF),
              onSurface: Color(0xFF1D1B1E),
              background: Color(0xFFFFF8F8),
              onBackground: Color(0xFF1D1B1E),
              error: Color(0xFFBA1A1A),
              onError: Colors.white,
              // Interactive state colors
              surfaceVariant: Color(0xFFF2DDE1),
              onSurfaceVariant: Color(0xFF514347),
              outline: Color(0xFF837377),
              outlineVariant: Color(0xFFD5C2C6),
            ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffffd2df),
          foregroundColor: Color(0xFFE91E63),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        scaffoldBackgroundColor:  Color(0xffffd2df),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE91E63),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Color(0xFFE91E63).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Color(0xFFE91E63)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFFE91E63),
            side: BorderSide(color: Color(0xFFE91E63)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFF837377)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(0xFFE91E63), width: 2),
          ),
          labelStyle: TextStyle(color: Color(0xFF514347)),
          hintStyle: TextStyle(color: Color(0xFF837377)),
        ),
        cardTheme: CardThemeData(
          color: Color(0xFFFFFBFF),
          surfaceTintColor: Color(0xFFE91E63),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
    );
  }
}
