import 'package:aplikacja_pogodowa/ui/configurations/configurations.dart';
import 'package:flutter/cupertino.dart';

abstract class TextStyles {
  static TextStyle appTitle = TextStyle(
    fontSize: 24,
    fontStyle: FontStyle.italic,
    shadows: [
      Shadow(
        color: AppColors.shadowColor.withOpacity(0.3),
        blurRadius: 3,
        offset: Offset(
          3,
          3,
        ),
      ),
    ],
  );
  static TextStyle appTitleAc = TextStyle(
    fontSize: 30,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: AppColors.shadowColor.withOpacity(0.2),
        blurRadius: 3,
        offset: Offset(
          5,
          5,
        ),
      ),
    ],
  );
  static const TextStyle h1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle normal = TextStyle(
    fontSize: 16,
  );
  static const TextStyle normalAc = TextStyle(
    fontSize: 20,
  );

  static const TextStyle acLocationLabelStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle acWeatherSummaryLabelStyle = TextStyle(
    fontSize: 34,
  );
  static const TextStyle acWeatherSummaryValueStyle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle acWeatherSummarySubLabelStyle = TextStyle(
    fontSize: 22,
  );
}
