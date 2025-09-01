import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';

final AppTheme = ThemeData(
  primaryColor: AppPalette.primaryColor,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme(
    primary: AppPalette.primaryColor,
    secondary: AppPalette.secondaryColor,
    surface: AppPalette.whiteColor,
    background: AppPalette.backgroundColor,
    error: AppPalette.errorColor,
    onPrimary: AppPalette.whiteColor,
    onSecondary: AppPalette.whiteColor,
    onSurface: AppPalette.textColor,
    onBackground: AppPalette.textColor,
    onError: AppPalette.whiteColor,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppPalette.primaryColor,
    foregroundColor: AppPalette.whiteColor,
    elevation: 0,
    iconTheme: IconThemeData(color: AppPalette.whiteColor),
    titleTextStyle: TextStyle(
      color: AppPalette.whiteColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppPalette.primaryColor,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppPalette.primaryColor,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppPalette.primaryColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppPalette.textColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppPalette.textColor,
    ),
    titleLarge: TextStyle(
      color: AppPalette.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodyLarge: TextStyle(color: AppPalette.textColor, fontSize: 16),
    bodyMedium: TextStyle(color: AppPalette.textColor, fontSize: 14),
    bodySmall: TextStyle(color: AppPalette.greyColor, fontSize: 12),
    labelLarge: TextStyle(
      color: AppPalette.primaryColor,
      fontWeight: FontWeight.w600,
    ),
  ),
  iconTheme: IconThemeData(color: AppPalette.primaryColor, size: 24),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppPalette.primaryColor,
      foregroundColor: AppPalette.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppPalette.primaryColor,
      side: BorderSide(color: AppPalette.primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppPalette.primaryColor,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF2F6F4),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppPalette.secondaryColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppPalette.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppPalette.errorColor, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppPalette.errorColor, width: 2),
    ),
    hintStyle: TextStyle(color: AppPalette.greyColor),
    labelStyle: TextStyle(color: AppPalette.primaryColor),
  ),
  cardTheme: CardThemeData(
    color: AppPalette.primaryColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //margin: const EdgeInsets.all(8),
  ),
  dividerTheme: DividerThemeData(
    color: AppPalette.greyColor,
    thickness: 1,
    space: 1,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppPalette.secondaryColor,
    disabledColor: AppPalette.greyColor,
    selectedColor: AppPalette.primaryColor,
    secondarySelectedColor: AppPalette.primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    labelStyle: TextStyle(color: Colors.white),
    secondaryLabelStyle: TextStyle(color: AppPalette.whiteColor),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppPalette.secondaryColor,
    foregroundColor: AppPalette.whiteColor,
    elevation: 4,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppPalette.whiteColor,
    selectedItemColor: AppPalette.primaryColor,
    unselectedItemColor: AppPalette.greyColor,
    selectedIconTheme: IconThemeData(color: AppPalette.primaryColor),
    unselectedIconTheme: IconThemeData(color: AppPalette.greyColor),
    showUnselectedLabels: true,
  ),
  tabBarTheme: TabBarThemeData(
    labelColor: AppPalette.primaryColor,
    unselectedLabelColor: AppPalette.greyColor,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppPalette.secondaryColor, width: 8),
    ),
    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppPalette.primaryColor,
    linearTrackColor: AppPalette.accentColor,
    circularTrackColor: AppPalette.accentColor,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppPalette.primaryColor,
    contentTextStyle: TextStyle(color: AppPalette.whiteColor),
    actionTextColor: AppPalette.accentColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
  ),
);
