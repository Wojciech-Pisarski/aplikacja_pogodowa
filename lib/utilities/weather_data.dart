import 'dart:async';

import 'package:aplikacja_pogodowa/utilities/http_helper.dart';
import 'package:aplikacja_pogodowa/enums/enums.dart';
import 'package:aplikacja_pogodowa/utilities/localization_helper.dart';
import 'package:aplikacja_pogodowa/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class WeatherData {
  static WeatherCheckMethod _weatherCheckMethod;
  static Map<Coordinates, double> _coordinates;
  static String _cityName;

  static String _apiCityName;
  static String _apiWeatherSummary;
  static String _weatherCheckDateString;
  static String _weatherCheckTimeString;
  static double _apiCurrentTemperature;
  static double _apiSensedTemperature;
  static double _apiPressure;
  static double _apiLongitude;
  static double _apiLatitude;
  static int _apiWeatherIconCode;
  static int _apiSunriseHour;
  static int _apiTwilightHour;
  static int _apiSunriseMinute;
  static int _apiTwilightMinute;

  static WeatherCheckMethod get weatherCheckMethod => _weatherCheckMethod;
  static String get cityName => _apiCityName;
  static String get weatherSummary {
    switch (_apiWeatherSummary) {
      case 'thunderstorm with light rain':
        return 'Burza z lekkim deszczem';
      case 'thunderstorm with rain':
        return 'Burza z deszczem';
      case 'thunderstorm with heavy rain':
        return 'Burza z ciężkim deszczem';
      case 'light thunderstorm':
        return 'Lekka burza';
      case 'thunderstorm':
        return 'Burza';
      case 'heavy thunderstorm':
        return 'Mocna burza';
      case 'ragged thunderstorm':
        return 'Nierówna burza';
      case 'thunderstorm with light drizzle':
        return 'Burza z lekkim mżawką';
      case 'thunderstorm with drizzle':
        return 'Burza z mżawką';
      case 'thunderstorm with heavy drizzle ':
        return 'Burza z mocną mrzawką';
      case 'light intensity drizzle':
        return 'Średnio intensywna mżawka';
      case 'drizzle':
        return 'Mżawka';
      case 'heavy intensity drizzle':
        return 'Mocno intensywna mżawka';
      case 'light intensity drizzle rain':
        return 'Słabo intensywna mżawka';
      case 'drizzle rain':
        return 'Mżawka';
      case 'heavy intensity drizzle rain':
        return 'Mocno intensywna mżawka';
      case 'shower rain and drizzle':
        return 'Ulewa';
      case 'heavy shower rain and drizzle':
        return 'Intensywna ulewa';
      case 'shower drizzle':
        return 'Intensywna mżawka';
      case 'light rain':
        return 'Lekki deszcz';
      case 'moderate rain':
        return 'Umiarkowany deszcz';
      case 'heavy intensity rain':
        return 'Intensywny deszcz';
      case 'very heavy rain':
        return 'Bardzo intensywny deszcz';
      case 'extreme rain':
        return 'Ekstremalnie intensywny deszcz';
      case 'freezing rain':
        return 'Logowaty deszcz';
      case 'light intensity shower rain':
        return 'Średnio intensywny deszcz';
      case 'shower rain':
        return 'Ulewa';
      case 'heavy intensity shower rain':
        return 'Mocno intensywna ulewa';
      case 'ragged shower rain':
        return 'Nieregularna ulewa';
      case 'light snow':
        return 'Lekki śnieg';
      case 'snow':
        return 'Śnieg';
      case 'heavy snow':
        return 'Mocny śnieg';
      case 'Sleet':
        return 'Śnieg z deszczem';
      case 'Light shower sleet':
        return 'Lekki deszcz ze śniegiem';
      case 'Shower sleet ':
        return 'Ulewa ze śniegiem';
      case 'Light rain and snow':
        return 'Lekki deszcz ze śniegiem';
      case 'Rain and snow':
        return 'Deszcz ze śniegiem';
      case 'Light shower snow':
        return 'Lekka ulewa ze śniegiem';
      case 'Shower snow':
        return 'Ulewa ze śniegiem';
      case 'Heavy shower snow':
        return 'Mocna ulewa ze śniegiem';
      case 'mist':
        return 'Zamglenie';
      case 'Smoke':
        return 'Dym';
      case 'Haze':
        return 'Mgła';
      case 'sand/ dust whirls':
        return 'Wiry piasku/pyłu';
      case 'fog':
        return 'Mgła';
      case 'sand':
        return 'Piasek';
      case 'dust':
        return 'Kurz';
      case 'volcanic ash':
        return 'Pył wulkaniczny';
      case 'squalls':
        return 'Wstrząsy';
      case 'tornado':
        return 'Tornado';
      case 'clear sky':
        return 'Czyste niebo';
      case 'few clouds':
        return 'Kilka chmur: 11-25%';
      case 'scattered clouds':
        return 'Rozsiane chmury: 25-50%';
      case 'broken clouds':
        return 'Porwane chmury: 51-84%';
      case 'overcast clouds':
        return 'Zachmurzenie: 85-100%';
      default:
        return "-";
    }
  }

  static double get currentTemperature => _apiCurrentTemperature;
  static double get sensedTemperature => _apiSensedTemperature;
  static double get pressure => _apiPressure;
  static IconData get weatherIcon {
    if (_apiWeatherIconCode >= 200 && _apiWeatherIconCode <= 232) {
      return Icons.bolt;
    } else if ((_apiWeatherIconCode >= 300 && _apiWeatherIconCode <= 321) ||
        (_apiWeatherIconCode >= 500 && _apiWeatherIconCode <= 531)) {
      return Icons.opacity;
    } else if (_apiWeatherIconCode >= 600 && _apiWeatherIconCode <= 622) {
      return Icons.ac_unit;
    } else if (_apiWeatherIconCode >= 701 && _apiWeatherIconCode <= 781) {
      return Icons.waves;
    } else if (_apiWeatherIconCode >= 801 && _apiWeatherIconCode <= 804) {
      return Icons.cloud;
    } else {
      return Icons.wb_sunny;
    }
  }

  static String get longitude {
    double long = double.parse(_apiLongitude.toStringAsFixed(2));
    if (long > 0) {
      return '$long°W';
    } else if (long < 0) {
      return '${-long}°E';
    }
    return long.toString();
  }

  static String get latitude {
    double lat = double.parse(_apiLatitude.toStringAsFixed(2));
    if (lat > 0) {
      return '$lat°N';
    } else if (lat < 0) {
      return '${-lat}°S';
    }
    return lat.toString();
  }

  static String get sunriseTime => _buildFormattedTime(
        _apiSunriseHour,
        _apiSunriseMinute,
      );
  static String get twilightTime => _buildFormattedTime(
        _apiTwilightHour,
        _apiTwilightMinute,
      );

  static String get weatherCheckDateString => _weatherCheckDateString;
  static String get weatherCheckTimeString => _weatherCheckTimeString;

  static getWeatherInfo({
    @required WeatherCheckMethod weatherCheckMethod,
    Map<WeatherDataInputType, String> weatherDataInput,
  }) async {
    try {
      _validateGetDataArguments(
        weatherCheckMethod: weatherCheckMethod,
        weatherDataInput: weatherDataInput,
      );
      await _initializeClassData(
        weatherCheckMethod: weatherCheckMethod,
        weatherDataInput: weatherDataInput,
      );
      await _getWeatherData();
    } catch (e) {
      throw (e);
    }
  }

  static _validateGetDataArguments({
    @required WeatherCheckMethod weatherCheckMethod,
    Map<WeatherDataInputType, String> weatherDataInput,
  }) {
    switch (weatherCheckMethod) {
      case WeatherCheckMethod.COORDINATES:
        try {
          _verifyCoordinateValue(
            longitude: double.tryParse(
                weatherDataInput[WeatherDataInputType.LONGITUDE]),
            latitude: double.tryParse(
                weatherDataInput[WeatherDataInputType.LATITUDE]),
          );
        } catch (exception) {
          throw "Incorrect coordinates data: $exception";
        }
        break;
      case WeatherCheckMethod.CITY_NAME:
        try {
          _verifyCityNameValue(
              weatherDataInput[WeatherDataInputType.CITY_NAME]);
        } catch (exception) {
          throw "Incorrect cityName data: $exception";
        }
        break;
      default:
    }
  }

  static _verifyCoordinateValue({
    @required double longitude,
    @required double latitude,
  }) {
    if (longitude == null) {
      throw "Longitude is null";
    }
    if (latitude == null) {
      throw "Latitude is null";
    }
    if (longitude.abs() > GeneralValues.longitudeBorderValue) {
      throw "Longitude over ${GeneralValues.longitudeBorderValue} degrees";
    }
    if (latitude.abs() > GeneralValues.latitudeBorderValue) {
      throw "Latitude over ${GeneralValues.latitudeBorderValue} degrees";
    }
  }

  static _verifyCityNameValue(String cityName) {
    if (cityName == null) {
      throw "City name is null";
    }
    if (cityName == "") {
      throw "City name is empty";
    }
  }

  static _initializeClassData({
    @required WeatherCheckMethod weatherCheckMethod,
    Map<WeatherDataInputType, String> weatherDataInput,
  }) async {
    _weatherCheckMethod = weatherCheckMethod;
    if (_weatherCheckMethod == WeatherCheckMethod.CURRENT_LOCATION) {
      await LocalizationHelper.updateData();
      _coordinates = {
        Coordinates.LATITUDE: await LocalizationHelper.latitude,
        Coordinates.LONGITUDE: await LocalizationHelper.longitude,
      };
    } else if (_weatherCheckMethod == WeatherCheckMethod.COORDINATES) {
      _coordinates = {
        Coordinates.LATITUDE:
            double.tryParse(weatherDataInput[WeatherDataInputType.LATITUDE]),
        Coordinates.LONGITUDE:
            double.tryParse(weatherDataInput[WeatherDataInputType.LONGITUDE]),
      };
    } else if (_weatherCheckMethod == WeatherCheckMethod.CITY_NAME) {
      _cityName = weatherDataInput[WeatherDataInputType.CITY_NAME];
    }
  }

  static _getWeatherData() async {
    _updateCheckDateAndTime();
    var networkData;
    try {
      networkData = await HttpHelper.getData(
        _weatherCheckMethod,
        _coordinates,
        _cityName,
      );
      _verifyNetworkData(networkData);
    } on TimeoutException catch (e) {
      throw e.message;
    } catch (e) {
      throw e;
    }
    _updateClassData(networkData);
  }

  static _verifyNetworkData(Map<String, dynamic> networkData) {
    if (networkData == null) throw 'Otrzymano pusty zestaw danych z API\n';
    // TODO: Add additional checks
  }

  static _updateClassData(Map<String, dynamic> networkData) {
    _apiCityName = networkData['name'];
    _apiLatitude = _provideDoubleForValue(networkData['coord']['lat']);
    _apiLongitude = _provideDoubleForValue(networkData['coord']['lon']);
    _apiWeatherSummary = networkData['weather'][0]['description'];
    _apiCurrentTemperature =
        _provideDoubleForValue(networkData['main']['temp']);
    _apiSensedTemperature =
        _provideDoubleForValue(networkData['main']['feels_like']);
    _apiPressure = _provideDoubleForValue(networkData['main']['pressure']);
    _apiWeatherIconCode = networkData['weather'][0]['id'];
    _updateSunriseTime(networkData['sys']['sunrise'] * 1000);
    _updateSunsetTime(networkData['sys']['sunset'] * 1000);
  }

  static _updateSunriseTime(int millisecondsSinceEpoch) {
    final sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    _apiSunriseHour = sunriseDateTime.hour;
    _apiSunriseMinute = sunriseDateTime.minute;
  }

  static _updateSunsetTime(int millisecondsSinceEpoch) {
    final sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    _apiTwilightHour = sunsetDateTime.hour;
    _apiTwilightMinute = sunsetDateTime.minute;
  }

  static double _provideDoubleForValue(dynamic value) {
    if (!(value is int || value is double)) {
      throw 'Podano zły typ wartości do konwersji na double ($value)\n';
    }
    return value is int ? value.toDouble() : value;
  }

  static _updateCheckDateAndTime() async {
    final dateTime = DateTime.now();
    _weatherCheckDateString = _buildFormattedDate(
      dateTime.day,
      dateTime.month,
      dateTime.year,
    );
    _weatherCheckTimeString = _buildFormattedTime(
      dateTime.hour,
      dateTime.minute,
    );
  }

  static String _buildFormattedDate(
    int day,
    int month,
    int year,
  ) {
    _validateDateArguments(
      day,
      month,
    );
    var validatedDay = _adjustDateOrTimeValue(day);
    var validatedMonth = _adjustDateOrTimeValue(month);
    var validatedYear = _adjustDateOrTimeValue(year);
    return '$validatedDay.$validatedMonth.$validatedYear';
  }

  static _validateDateArguments(
    int day,
    int month,
  ) {
    var errorMessage;
    if (month == null || month > 12 || month < 1) {
      errorMessage = errorMessage + 'Niepoprawna wartość miesiąca ($month)\n';
    } else if (day == null || day > 31 || day < 1) {
      errorMessage = errorMessage + 'Niepoprawna wartość dnia ($day)\n';
    } else if (day > 29 && month == 2) {
      errorMessage = errorMessage +
          'Niepoprawna wartość dnia ($day) dla miesiąca ($month)\n';
    }
    if (errorMessage != null) {
      throw errorMessage;
    }
  }

  static String _buildFormattedTime(
    int hour,
    int minute,
  ) {
    _validateTimeArguments(hour, minute);
    var validatedHour = _adjustDateOrTimeValue(hour);
    var validatedMinute = _adjustDateOrTimeValue(minute);
    return '$validatedHour:$validatedMinute';
  }

  static _validateTimeArguments(
    int hour,
    int minute,
  ) {
    var errorMessage;
    if (hour == null || hour > 24 || hour < 0) {
      errorMessage = errorMessage + 'Niepoprawna wartość godziny ($hour)\n';
    } else if (minute == null || minute > 60 || minute < 0) {
      errorMessage = errorMessage + 'Niepoprawna wartość minuty ($minute)\n';
    }
    if (errorMessage != null) {
      throw errorMessage;
    }
  }

  static String _adjustDateOrTimeValue(int value) =>
      value < 10 ? '0$value' : value.toString();
}
