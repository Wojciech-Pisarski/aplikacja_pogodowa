import 'package:aplikacja_pogodowa/enums/enums.dart';
import 'package:aplikacja_pogodowa/resources/resources.dart';
import 'package:aplikacja_pogodowa/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aplikacja_pogodowa/ui/ui.dart';

class ResultsScreen extends StatelessWidget {
  static const TAG = '/results_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).backgroundColor.withOpacity(0.9),
              ],
            ),
          ),
          child: _buildAppropriateUI(),
        ),
      ),
    );
  }

  Widget _buildAppropriateUI() => GeneralAppSettings.isInAccessibilityMode
      ? _buildAcUI()
      : _buildNormalUI();

  Widget _buildNormalUI() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Paddings.big,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 7,
              child: _buildHighlightWeatherInformation(),
            ),
            Expanded(
              flex: 2,
              child: _buildSunriseSundownInformation(),
            ),
            Expanded(
              flex: 3,
              child: _buildWeatherDataInformation(),
            ),
            Expanded(
              flex: 2,
              child: _buildDateTimeInformation(),
            ),
          ],
        ),
      );

  Column _buildHighlightWeatherInformation() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHighlightWeatherIcon(),
          _buildHighlightWeatherSummary(),
          _buildHighlightCityName(),
        ],
      );

  Icon _buildHighlightWeatherIcon() => Icon(
        Icons.wb_sunny_outlined,
        size: 6 * TextStyles.appTitle.fontSize,
      );

  Widget _buildHighlightWeatherSummary() => Padding(
        padding: const EdgeInsets.only(
          top: Paddings.big,
        ),
        child: Text(
          WeatherData.weatherSummary,
          style: TextStyles.appTitle.copyWith(
            fontStyle: FontStyle.normal,
          ),
        ),
      );

  Text _buildHighlightCityName() => Text(
        WeatherData.weatherCheckMethod == WeatherCheckMethod.CITY_NAME
            ? WeatherData.cityName
            : '${WeatherData.latitude} ${WeatherData.longitude}',
        style: TextStyles.h3.copyWith(
          fontWeight: FontWeight.normal,
        ),
      );

  Row _buildSunriseSundownInformation() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSunriseInfo(),
          _buildSundownInfo(),
        ],
      );

  Row _buildSunriseInfo() => _buildSunriseSundownInfographic(
        Icon(
          Icons.wb_sunny,
          size: 2 * TextStyles.appTitle.fontSize,
        ),
        Text(
          _validateAndProvideSunriseSunsetTime(WeatherData.sunriseTime),
          style: TextStyles.h1.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      );

  Row _buildSundownInfo() => _buildSunriseSundownInfographic(
        Text(
          _validateAndProvideSunriseSunsetTime(WeatherData.twilightTime),
          style: TextStyles.h1.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        Icon(
          Icons.wb_twighlight,
          size: 2 * TextStyles.appTitle.fontSize,
        ),
      );

  Row _buildSunriseSundownInfographic(
    Widget leftWidget,
    Widget rightWidget,
  ) =>
      Row(
        children: [
          leftWidget,
          SizedBox(
            width: Paddings.normal,
          ),
          rightWidget,
        ],
      );

  Column _buildWeatherDataInformation() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: double.maxFinite,
          ),
          _buildCurrentTemperatureRow(),
          _buildSensedTemperatureRow(),
          _buildPressureRow(),
        ],
      );

  _buildCurrentTemperatureRow() => _buildRowGeneralData(
        'Temperatura:',
        WeatherData.currentTemperature, //.toDouble(),
        '°C',
      );

  _buildSensedTemperatureRow() => _buildRowGeneralData(
        'Temperatura odczuwalna:',
        WeatherData.sensedTemperature, //.toDouble(),
        '°C',
      );

  _buildPressureRow() => _buildRowGeneralData(
        'Ciśnienie:',
        WeatherData.pressure.toDouble(),
        'hPa',
      );

  Row _buildRowGeneralData(
    String label,
    double value,
    String units,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyles.h2.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$value $units',
            style: TextStyles.h2,
          ),
        ],
      );

  Widget _buildDateTimeInformation() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Data i czas sprawdzania:',
            style: TextStyles.normal,
          ),
          Text(
            '${WeatherData.weatherCheckDateString}   ${WeatherData.weatherCheckTimeString}',
            style: TextStyles.h3,
          )
        ],
      );

  Widget _buildAcUI() => ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Paddings.small,
        ),
        children: [
          _buildAcGeneralInfo(),
          _buildAcTemperatureInfo(),
          _buildAcSunriseSundownInfo(),
          _buildAcOtherInfo(),
        ],
      );

  Widget _buildAcGeneralInfo() => Padding(
        padding: const EdgeInsets.only(
          top: Paddings.huge,
          bottom: Paddings.normal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                WeatherData.weatherCheckMethod == WeatherCheckMethod.CITY_NAME
                    ? WeatherData.cityName
                    : '${WeatherData.latitude} ${WeatherData.longitude}',
                style: TextStyles.acLocationLabelStyle,
                textAlign: TextAlign.center,
              ),
            ),
            _buildAcLabelText(WeatherData.weatherSummary),
          ],
        ),
      );

  Widget _buildAcTemperatureInfo() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Paddings.big,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAcValueText('${WeatherData.currentTemperature} °C'),
                  _buildAcSubLabelText("(rzeczywista)"),
                  _buildAcValueText('${WeatherData.sensedTemperature} °C'),
                  _buildAcSubLabelText("(odczuwalna)"),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Icon(
                  Icons.wb_sunny_outlined,
                  size: constraints.biggest.width,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAcSunriseSundownInfo() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Paddings.big,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAcSunriseSundownLabels(),
            _buildAcSunriseSundownValues(),
          ],
        ),
      );

  Widget _buildAcSunriseSundownLabels() => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAcLabelText('Wschód'),
            _buildAcLabelText('Zachód'),
          ],
        ),
      );

  Widget _buildAcSunriseSundownValues() => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAcValueText(
                _validateAndProvideSunriseSunsetTime(WeatherData.sunriseTime)),
            _buildAcValueText(
                _validateAndProvideSunriseSunsetTime(WeatherData.twilightTime)),
          ],
        ),
      );

  Widget _buildAcOtherInfo() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Paddings.normal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAcPressureRow(),
            _buildAcCheckTime(),
            _buildAcCheckDate(),
          ],
        ),
      );

  Row _buildAcPressureRow() => _buildAcRowOtherData(
        'Ciśnienie',
        WeatherData.pressure.toString(),
        units: 'hPa',
      );

  Row _buildAcCheckTime() => _buildAcRowOtherData(
        'Godzina sprawdzenia',
        WeatherData.weatherCheckTimeString,
      );

  Row _buildAcCheckDate() => _buildAcRowOtherData(
        'Data sprawdzenia',
        WeatherData.weatherCheckDateString,
      );

  Row _buildAcRowOtherData(String label, String value, {String units}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAcRowCenteredElement(
            _buildAcLabelText(label),
            flexValue: 8,
          ),
          _buildAcRowCenteredElement(
            _buildAcValueText(units != null ? '$value $units' : value),
            flexValue: 7,
          ),
        ],
      );

  Flexible _buildAcRowCenteredElement(Widget child, {int flexValue = 1}) =>
      Flexible(
        flex: flexValue,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.normal,
            ),
            child: child,
          ),
        ),
      );

  Text _buildAcLabelText(String label) => Text(
        label,
        style: TextStyles.acWeatherSummaryLabelStyle,
        textAlign: TextAlign.center,
      );

  Text _buildAcSubLabelText(String label) => Text(
        label,
        style: TextStyles.acWeatherSummarySubLabelStyle,
        textAlign: TextAlign.center,
      );

  Text _buildAcValueText(String label) => Text(
        label,
        style: TextStyles.acWeatherSummaryValueStyle,
        textAlign: TextAlign.center,
      );

  String _validateAndProvideSunriseSunsetTime(String timeArgument) {
    final time = timeArgument == WeatherData.sunriseTime
        ? WeatherData.sunriseTime
        : WeatherData.twilightTime;
    if (time == WeatherData.sunriseTime) {
      return time == WeatherData.twilightTime ? '-' : time;
    } else if (time == WeatherData.twilightTime) {
      return time == WeatherData.sunriseTime ? '-' : time;
    }
  }
}
