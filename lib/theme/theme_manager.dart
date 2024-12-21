import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../enum/enum_theme_type.dart';
import '../utils/colors_utils.dart';
import '../utils/const.dart';
import '../utils/session_manager.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode getThemeMode() => _themeMode;

  ThemeNotifier() {
    setSavedThemeMode();
  }

  ThemeData lightThemeData(BuildContext context) {
    // light theme
    return ThemeData.light().copyWith(
      appBarTheme: getAppBarTheme(context),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      backgroundColor: whiteColor,
      scaffoldBackgroundColor: whiteColor,
      accentColor: accentColor,
      dividerColor: dividerColor,
      errorColor: errorRedColor,
      disabledColor: disableColor,
      buttonColor: primaryColor,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return primaryColor;
            },
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
      ),
      secondaryHeaderColor: secondaryTextColor,
      accentIconTheme: const IconThemeData(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      unselectedWidgetColor: primaryTextColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: lightPrimaryColor,
        error: errorRedColor,
      ),

      // text theme
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  ThemeData darkThemeData(BuildContext context) {
    // dark theme
    return ThemeData.dark().copyWith(
      // appBarTheme: appBarTheme,
      brightness: Brightness.light,
      primaryColor: primaryColorDark,
      backgroundColor: whiteColor,
      scaffoldBackgroundColor: whiteColor,
      accentColor: accentColorDark,
      dividerColor: dividerColorDark,
      errorColor: errorRedColor,
      disabledColor: disableColorDark,
      buttonColor: accentColorDark,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return accentColorDark;
            },
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColorDark,
      ),
      secondaryHeaderColor: secondaryTextColorDark,
      accentIconTheme: const IconThemeData(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      unselectedWidgetColor: primaryTextColorDark,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: primaryColorDark,
        secondary: lightPrimaryColorDark,
        error: errorRedColor,
      ),
    );
  }

  /// get appbar theme
  AppBarTheme getAppBarTheme(BuildContext context) {
    return AppBarTheme.of(context).copyWith(
      centerTitle: false,
      backgroundColor: whiteColor,
      titleTextStyle: GoogleFonts.poppins(
        color: primaryColor,
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
      ),
    );
  }

  /// change theme mode based on shared pref values
  void changeThemeMode(int value) {
    SessionManager.setIntValue(Const.spThemeMode, value)
        .then((value) => setSavedThemeMode());
  }

  /// set saved theme mode based on shared pref values
  void setSavedThemeMode() {
    SessionManager.getIntValue(Const.spThemeMode).then((value) {
      if (value == ThemeType.light.value) {
        _themeMode = ThemeMode.light;
      } else if (value == ThemeType.dark.value) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = getSystemDefaultTheme();
      }
      notifyListeners();
    });
  }

  /// get system default theme mode
  ThemeMode getSystemDefaultTheme() {
    // get brightness of system
    var brightness = getSystemDefaultBrightness();
    if (brightness == Brightness.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
  }

  /// get system default brightness to check system mode light/dark
  Brightness getSystemDefaultBrightness() {
    return SchedulerBinding.instance.window.platformBrightness;
  }
}
