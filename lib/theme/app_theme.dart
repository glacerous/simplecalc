import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Awesomic Design System Tokens & Light Theme
class AppTheme {
  static const Color cobalt = Color(0xFF2563EB);   // Electric Cobalt (secondary accent)
  static const Color obsidian = Color(0xFF09090B); // Dark neutral (primary/text)
  static const Color graphite = Color(0xFF18181B); // Body text
  static const Color fog = Color(0xFF71717A);      // Muted helper text
  static const Color ash = Color(0xFFA1A1AA);      // Disabled/placeholder
  static const Color cloud = Color(0xFFECECEE);    // Hairline 1px border
  static const Color paper = Color(0xFFF4F4F5);    // Screen background
  static const Color snow = Color(0xFFFFFFFF);     // Card / container surface

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: const ColorScheme.light(
        primary: obsidian,
        onPrimary: snow,
        secondary: cobalt,
        onSecondary: snow,
        surface: snow,
        onSurface: graphite,
        outline: cloud,
      ),
      textTheme: GoogleFonts.dmSansTextTheme().apply(
        bodyColor: graphite,
        displayColor: obsidian,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: snow,
        foregroundColor: obsidian,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dmSans(
          color: obsidian,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: obsidian),
        shape: const Border(bottom: BorderSide(color: cloud, width: 1)),
      ),
      cardTheme: CardThemeData(
        color: snow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cloud, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cobalt,
        foregroundColor: snow,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: cobalt),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cobalt : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? snow : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cobalt : null,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: cobalt,
        selectionColor: Color(0x332563EB),
        selectionHandleColor: cobalt,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: snow,
        headerBackgroundColor: obsidian,
        headerForegroundColor: snow,
        todayForegroundColor: WidgetStateProperty.all(cobalt),
        todayBorder: const BorderSide(color: cobalt),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? snow : graphite,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cobalt : null,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cloud, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: obsidian,
          foregroundColor: snow,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: obsidian,
          side: const BorderSide(color: cloud, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: snow,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cloud, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cloud, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cobalt, width: 1.5),
        ),
        labelStyle: const TextStyle(color: fog),
        floatingLabelStyle: const TextStyle(color: cobalt),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: snow,
        selectedItemColor: cobalt,
        unselectedItemColor: fog,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
}
