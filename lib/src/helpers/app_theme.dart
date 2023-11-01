import 'package:flutter/material.dart';
import 'app_constants.dart' as constants;

class AppTheme {
  late final ThemeData _appLightTheme;
  final AppBarTheme _appBarTheme = const AppBarTheme(
    backgroundColor: constants.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
  );
  AppTheme() {
    _appLightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: constants.primaryColor,
      // colorScheme:
      //     ColorScheme.fromSwatch(accentColor: constants.secondaryColor),
      colorScheme: const ColorScheme.light(secondary: constants.secondaryColor),
      primarySwatch: constants.primarySwatchColor,
      scaffoldBackgroundColor: constants.scaffoldBGC,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: constants.primaryColor,
      ),
      appBarTheme: _appBarTheme,
    );
  }

  ThemeData getAppLightTheme() {
    return _appLightTheme;
  }
}
