import 'package:aplikacja_pogodowa/resources/app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'ui/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GeneralAppSettings.currentTheme, //_currentTheme,
      darkTheme: ThemeDatas.darkTheme,
      initialRoute: HomeScreen.TAG,
      routes: {
        HomeScreen.TAG: (context) => HomeScreen(
              switchThemeFunction: _switchTheme,
            ),
        ResultsScreen.TAG: (context) => ResultsScreen(),
      },
    );
  }

  _switchTheme() {
    if (GeneralAppSettings.currentTheme == ThemeDatas.lightTheme) {
      setState(() {
        GeneralAppSettings.currentTheme = ThemeDatas.darkTheme;
      });
    } else {
      setState(() {
        GeneralAppSettings.currentTheme = ThemeDatas.lightTheme;
      });
    }
  }
}
