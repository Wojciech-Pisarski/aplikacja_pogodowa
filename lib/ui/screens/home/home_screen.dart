import 'dart:async';

import 'package:aplikacja_pogodowa/enums/enums.dart';
import 'package:aplikacja_pogodowa/ui/configurations/themes/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aplikacja_pogodowa/ui/ui.dart';
import 'package:aplikacja_pogodowa/resources/resources.dart';
import 'package:aplikacja_pogodowa/utilities/utilities.dart';

class HomeScreen extends StatefulWidget {
  static const TAG = '/home_screen';
  final Function switchThemeFunction;

  const HomeScreen({
    @required this.switchThemeFunction,
  }) : assert(switchThemeFunction != null);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInAccessibilityMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: _buildBackgroundDecoration(
                      Theme.of(context).backgroundColor.withOpacity(0.9),
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildAppTitle(),
                        ),
                        Expanded(
                          flex: 7,
                          child: _buildMainButtons(),
                        ),
                        Expanded(
                          child: _buildSettingsCustomFAB(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (OverlaySettings.isLoadingOverlayDisplayed) _buildLoadingOverlay(),
          if (OverlaySettings.errorMessage.trim().isNotEmpty)
            _buildErrorOverlay(),
        ],
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration(
    Color topColor,
    Color bottomColor,
  ) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      );

  Widget _buildLoadingOverlay() => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: _buildBackgroundDecoration(
            Theme.of(context).backgroundColor.withOpacity(0.8),
            Theme.of(context).primaryColor.withOpacity(0.9),
          ),
          child: Center(
            child: Text(
              'Ładowanie danych pogodowych...',
              style: TextStyles.h1,
            ),
          ),
        ),
      );

  Widget _buildErrorOverlay() => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: _buildBackgroundDecoration(
            Colors.redAccent.withOpacity(0.8),
            Colors.red.withOpacity(0.9),
          ),
          child: Center(
            child: Text(
              'Wystąpił błąd:\n\n${OverlaySettings.errorMessage}',
              style: TextStyles.h1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  Widget _buildAppTitle() => Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          '${GeneralStrings.appName}',
          style: GeneralAppSettings.isInAccessibilityMode
              ? TextStyles.appTitleAc
              : TextStyles.appTitle,
        ),
      );

  Widget _buildMainButtons() => Padding(
        padding: const EdgeInsets.all(
          Paddings.big,
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildCheckWeatherLabel(),
              _buildProperMenuButtonWithPadding(
                categoryIcon: Icons.location_on_outlined,
                actionName: "Po aktualnej lokalizacji",
                onPress: _currentLocationMethodOnPress,
              ),
              _buildProperMenuButtonWithPadding(
                categoryIcon: Icons.location_city_outlined,
                actionName: "Po nazwie miasta",
                onPress: _buildCityInputBottomSheet,
              ),
              _buildProperMenuButtonWithPadding(
                categoryIcon: Icons.map_sharp,
                actionName: "Po współrzędnych geograficznych",
                onPress: _buildCoordinatesInputBottomSheet,
              ),
            ],
          ),
        ),
      );

  Widget _buildCheckWeatherLabel() => Center(
        child: Text(
          'Sprawdź pogodę...',
          style: GeneralAppSettings.isInAccessibilityMode
              ? TextStyles.normalAc
              : TextStyles.normal,
        ),
      );

  _currentLocationMethodOnPress() async {
    _toggleOverlay();
    try {
      await WeatherData.getWeatherInfo(
        weatherCheckMethod: WeatherCheckMethod.CURRENT_LOCATION,
      );
    } catch (e) {
      await _toggleOverlay(
        errorMessage: '$e',
      );
      return;
    }
    _toggleOverlay();
    Navigator.pushNamed(
      context,
      ResultsScreen.TAG,
    );
  }

  _cityNameMethodOnPress(
    Map<WeatherDataInputType, String> weatherDataInput,
  ) async {
    Navigator.pop(context);
    _toggleOverlay();
    try {
      await WeatherData.getWeatherInfo(
        weatherCheckMethod: WeatherCheckMethod.CITY_NAME,
        weatherDataInput: weatherDataInput,
      );
    } catch (e) {
      await _toggleOverlay(
        errorMessage: '$e',
      );
      return;
    }
    _toggleOverlay();
    Navigator.pushNamed(
      context,
      ResultsScreen.TAG,
    );
  }

  _coordinatesMethodOnPress(
    Map<WeatherDataInputType, String> weatherDataInput,
  ) async {
    Navigator.pop(context);
    _toggleOverlay();
    try {
      await WeatherData.getWeatherInfo(
        weatherCheckMethod: WeatherCheckMethod.COORDINATES,
        weatherDataInput: weatherDataInput,
      );
    } catch (e) {
      await _toggleOverlay(
        errorMessage: '$e',
      );
      return;
    }
    _toggleOverlay();
    Navigator.pushNamed(
      context,
      ResultsScreen.TAG,
    );
  }

  _toggleOverlay({
    String errorMessage = "",
  }) async {
    if (errorMessage.trim().isEmpty) {
      setState(() {
        if (OverlaySettings.isLoadingOverlayDisplayed) {
          OverlaySettings.isLoadingOverlayDisplayed = false;
        } else {
          OverlaySettings.isLoadingOverlayDisplayed = true;
        }
      });
    } else {
      setState(() {
        OverlaySettings.isLoadingOverlayDisplayed = false;
        OverlaySettings.isErrorOverlayDisplayed = true;
        OverlaySettings.errorMessage = errorMessage;
      });
      await Future.delayed(
        Duration(
          seconds: 5,
        ),
      );
      setState(() {
        OverlaySettings.isErrorOverlayDisplayed = false;
        OverlaySettings.errorMessage = "";
      });
    }
  }

  _buildCityInputBottomSheet() => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => BottomSheetFormWidget(
          onPressContinue: _cityNameMethodOnPress,
          title: "Po nazwie miasta",
          bottomSheetFormWidgetDtoList: [
            BottomSheetFormDto(
              label: "Nazwa miasta",
              weatherDataInputType: WeatherDataInputType.CITY_NAME,
            ),
          ],
        ),
      );

  _buildCoordinatesInputBottomSheet() => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => BottomSheetFormWidget(
          onPressContinue: _coordinatesMethodOnPress,
          title: "Po współrzędnych geograficznych",
          bottomSheetFormWidgetDtoList: [
            BottomSheetFormDto(
              label: "Szerokość geograficzna",
              weatherDataInputType: WeatherDataInputType.LATITUDE,
              isNumericValue: true,
              lowerBound: -GeneralValues.latitudeBorderValue,
              upperBound: GeneralValues.latitudeBorderValue,
            ),
            BottomSheetFormDto(
              label: "Długość geograficzna",
              weatherDataInputType: WeatherDataInputType.LONGITUDE,
              isNumericValue: true,
              lowerBound: -GeneralValues.longitudeBorderValue,
              upperBound: GeneralValues.longitudeBorderValue,
            ),
          ],
        ),
      );

  Widget _buildProperMenuButtonWithPadding({
    @required IconData categoryIcon,
    @required String actionName,
    @required Function onPress,
  }) =>
      GeneralAppSettings.isInAccessibilityMode
          ? _buildMenuButtonWithPadding(
              categoryIcon: categoryIcon,
              actionName: actionName,
              onPress: onPress,
            )
          : Center(
              child: _buildMenuButtonWithPadding(
                categoryIcon: categoryIcon,
                actionName: actionName,
                onPress: onPress,
              ),
            );

  Widget _buildAcMenuButtonWithPadding({
    @required IconData categoryIcon,
    @required String actionName,
    @required Function onPress,
  }) =>
      Expanded(
        child: _buildMenuButtonWithPadding(
          categoryIcon: categoryIcon,
          actionName: actionName,
          onPress: onPress,
        ),
      );

  Widget _buildMenuButtonWithPadding({
    @required IconData categoryIcon,
    @required String actionName,
    @required Function onPress,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Paddings.normal,
        ),
        child: WeatherCheckTypeButton(
          categoryIcon: categoryIcon,
          actionName: actionName,
          onPress: onPress,
        ),
      );

  Widget _buildSettingsCustomFAB() => SettingsCustomFloatingActionButton(
        accessibilitySwitchFunction: () =>
            setState(() => _switchAccessibilityMode()),
        themeModeSwitchFunction: () => setState(widget.switchThemeFunction),
      );

  _switchAccessibilityMode() {
    setState(() {
      GeneralAppSettings.isInAccessibilityMode =
          !GeneralAppSettings.isInAccessibilityMode;
    });
  }
}
