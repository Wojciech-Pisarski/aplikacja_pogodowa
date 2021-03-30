import 'package:flutter/material.dart';
import 'package:aplikacja_pogodowa/ui/ui.dart';
import 'enums.dart';

abstract class GeneralAppSettings {
  static bool isInAccessibilityMode = false;
  static ThemeType themeType = ThemeType.LIGHT;
  static ThemeData currentTheme = ThemeDatas.lightTheme;
}
