import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color mainColor = Color(0xFFFFF763);
  static const Color mainColorDarker = Color(0xFFB4AF52);
  static const Map<int, Color> materialMainColor = {
    50: Color.fromRGBO(255, 247, 99, .1),
    100: Color.fromRGBO(255, 247, 99, .2),
    200: Color.fromRGBO(255, 247, 99, .3),
    300: Color.fromRGBO(255, 247, 99, .4),
    400: Color.fromRGBO(255, 247, 99, .5),
    500: Color.fromRGBO(255, 247, 99, .6),
    600: Color.fromRGBO(255, 247, 99, .7),
    700: Color.fromRGBO(255, 247, 99, .8),
    800: Color.fromRGBO(255, 247, 99, .9),
    900: Color.fromRGBO(255, 247, 99, 1),
  };
  static const Color secondaryColor = Color(0xFFF9C42D);
  static const Color secondaryColorDarker = Color(0xFFC79C1D);
  static const Map<int, Color> materialSecondaryColor = {
    50: Color.fromRGBO(249, 196, 45, .1),
    100: Color.fromRGBO(249, 196, 45, .2),
    200: Color.fromRGBO(249, 196, 45, .3),
    300: Color.fromRGBO(249, 196, 45, .4),
    400: Color.fromRGBO(249, 196, 45, .5),
    500: Color.fromRGBO(249, 196, 45, .6),
    600: Color.fromRGBO(249, 196, 45, .7),
    700: Color.fromRGBO(249, 196, 45, .8),
    800: Color.fromRGBO(249, 196, 45, .9),
    900: Color.fromRGBO(249, 196, 45, 1),
  };
  static const Color shadowColor = Color(0xFF000000);
  static const Color shadowColorDarker = Color(0xFFCECECE);
  static const Color borderColor = Color(0xFF696969);
  static const Color borderColorDarker = Color(0xFFFFFFFF);
}
