import 'package:flutter/cupertino.dart';
import 'package:aplikacja_pogodowa/enums/enums.dart';

class BottomSheetFormDto {
  final String label;
  final bool isNumericValue;
  final double lowerBound;
  final double upperBound;
  final WeatherDataInputType weatherDataInputType;

  BottomSheetFormDto({
    @required this.label,
    @required this.weatherDataInputType,
    this.isNumericValue = false,
    this.lowerBound,
    this.upperBound,
  }) : assert((isNumericValue &&
                lowerBound != null &&
                upperBound != null &&
                weatherDataInputType != null &&
                lowerBound <= upperBound) ||
            (!isNumericValue && lowerBound == null && upperBound == null));
}
