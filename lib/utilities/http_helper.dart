import 'dart:async';

import 'package:aplikacja_pogodowa/enums/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class HttpHelper {
  static const String API_KEY = '99776427feba057e0b7e7463c31ac3da';
  static const String URL_PREFIX = 'https://';
  static const String BASE_URL = 'api.openweathermap.org/data/2.5/weather?';
  static const String UNITS = 'metric';

  static Future<Map<String, dynamic>> getData(
    WeatherCheckMethod weatherCheckMethod,
    Map<Coordinates, double> coordinates,
    String cityName,
  ) async {
    try {
      _validateGetDataArguments(
        weatherCheckMethod,
        coordinates,
        cityName,
      );
      String unencodedPath = '&units=$UNITS&appid=$API_KEY';
      switch (weatherCheckMethod) {
        case WeatherCheckMethod.CITY_NAME:
          unencodedPath = 'q=$cityName$unencodedPath';
          break;
        default:
          unencodedPath =
              'lat=${coordinates[Coordinates.LATITUDE]}&lon=${coordinates[Coordinates.LONGITUDE]}$unencodedPath';
          break;
      }
      var data = await http
          .get(Uri.parse('$URL_PREFIX$BASE_URL$unencodedPath'))
          .timeout(
            Duration(
              seconds: 5,
            ),
          );
      if (data.statusCode != 200) {
        throw "Coś poszło nie tak przy pobieraniu danych Lo(kod: ${data.statusCode})";
      }
      return jsonDecode(data.body);
    } on TimeoutException catch (e) {
      throw TimeoutException(
          "Próba odebrania danych ze strony trwała zbyt długo");
    } catch (e) {
      throw e;
    }
  }

  static _validateGetDataArguments(
    WeatherCheckMethod weatherCheckMethod,
    Map<Coordinates, double> coordinates,
    String cityName,
  ) {
    if (weatherCheckMethod == WeatherCheckMethod.CITY_NAME) {
      if (cityName.trim() == "") {
        throw 'Nie podano nazwy miasta';
      }
    } else {
      if (coordinates[Coordinates.LONGITUDE] == null ||
          coordinates[Coordinates.LATITUDE] == null) {
        throw 'Nie podano współrzędnych geograficznych';
      }
    }
  }
}
