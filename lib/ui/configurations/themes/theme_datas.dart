import 'package:aplikacja_pogodowa/ui/configurations/configurations.dart';
import 'package:flutter/material.dart';

abstract class ThemeDatas {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    /* textTheme: TextTheme(
      headline5:
    ),*/
    //TODO: Adjust those values
    primaryColor: AppColors
        .mainColor, //MaterialColor(1, AppColors.materialSecondaryColor),
    backgroundColor: AppColors.secondaryColor,
    shadowColor: AppColors.shadowColor,
    accentColor: AppColors.borderColor,
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.mainColorDarker,
    backgroundColor: AppColors.secondaryColorDarker,
    shadowColor: AppColors.shadowColorDarker,
    accentColor: AppColors.borderColorDarker,
  );

  //static ThemeData a = ThemeData.light().f;
}
