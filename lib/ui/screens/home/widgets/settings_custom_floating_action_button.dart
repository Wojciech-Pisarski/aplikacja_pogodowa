import 'package:flutter/cupertino.dart';
import 'package:aplikacja_pogodowa/ui/configurations/configurations.dart';
import 'package:flutter/material.dart';
import 'package:aplikacja_pogodowa/resources/resources.dart';
import 'dart:math' as math;

class SettingsCustomFloatingActionButton extends StatefulWidget {
  final Function accessibilitySwitchFunction;
  final Function themeModeSwitchFunction;

  const SettingsCustomFloatingActionButton({
    @required this.accessibilitySwitchFunction,
    @required this.themeModeSwitchFunction,
  })  : assert(accessibilitySwitchFunction != null),
        assert(themeModeSwitchFunction != null);

  @override
  _SettingsCustomFloatingActionButtonState createState() =>
      _SettingsCustomFloatingActionButtonState();
}

class _SettingsCustomFloatingActionButtonState
    extends State<SettingsCustomFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _rotationAnimation;
  Animation _horizontalSlideAnimation;
  Animation _horizontalSlideAnimation2;
  bool _settingsExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<Offset> _buildHorizontalOffsetAnimation({
    @required double position,
  }) =>
      Tween<Offset>(
        begin: Offset(
          position,
          1,
        ),
        end: Offset(
          position,
          0,
        ),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final double shorterCFABMessageWidth =
        ComponentSizes.customFABMessageWidth -
            ComponentSizes.floatingActionButtonSize / 2;
    final double longerCFABMessageWidth =
        shorterCFABMessageWidth + ComponentSizes.iconSize / 2;
    return Container(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: ComponentSizes.floatingActionButtonSize / 2 +
                ComponentSizes.weatherCheckTypeButtonBorderSize,
            child: Container(
              padding: EdgeInsets.only(
                top: ComponentSizes.weatherCheckTypeButtonBorderSize,
              ),
              child: Stack(
                children: [
                  _buildCFABMessageWidget(
                    context,
                    animation: _horizontalSlideAnimation,
                    iconData: _chooseAccessibilitySwitchIcon(),
                    width: shorterCFABMessageWidth,
                    message: _chooseAccessibilitySwitchText(),
                    onPress: widget.accessibilitySwitchFunction,
                  ),
                  _buildCFABMessageWidget(
                    context,
                    animation: _horizontalSlideAnimation2,
                    iconData: _chooseThemeSwitchIcon(),
                    width: longerCFABMessageWidth,
                    message: _chooseThemeSwitchText(),
                    onPress: () =>
                        setState(() => widget.themeModeSwitchFunction()),
                  ),
                ],
              ),
            ),
          ),
          _buildDecoratedMainFAButton(context),
        ],
      ),
    );
  }

  _initializeController() {
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short,
    );
    _animationController.addListener(() => setState(() {}));
  }

  _initializeAnimations() {
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0,
          1,
        ),
      ),
    );
    _horizontalSlideAnimation = _buildHorizontalOffsetAnimation(
      position: -1,
    );
    _horizontalSlideAnimation2 = _buildHorizontalOffsetAnimation(
      position: 0,
    );
  }

  Widget _buildDecoratedMainFAButton(
    BuildContext context,
  ) =>
      _buildPositionedRightBottom(
        rightIndent: ComponentSizes.weatherCheckTypeButtonBorderSize,
        child: _buildMainFAButtonWithBorder(),
      );

  Widget _buildMainFAButtonWithBorder() => Container(
        height: GeneralAppSettings.isInAccessibilityMode
            ? ComponentSizes.floatingActionButtonAcSize
            : ComponentSizes.floatingActionButtonSize,
        decoration: _buildMainFAButtonBorderDecoration(),
        child: _buildMainFAButton(),
      );

  BoxDecoration _buildMainFAButtonBorderDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        border: Border.symmetric(
          horizontal: BorderSide(
            width: ComponentSizes.weatherCheckTypeButtonBorderSize,
            color: Theme.of(context).accentColor.withOpacity(0.2),
          ),
          vertical: BorderSide(
            width: ComponentSizes.weatherCheckTypeButtonBorderSize,
            color: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        ),
      );

  Widget _buildMainFAButton() => FittedBox(
        child: Container(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.9),
            child: Transform.rotate(
              angle: _rotationAnimation.value * 0.5 * math.pi,
              child: Icon(
                Icons.settings,
                size: ComponentSizes.iconSize,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
            onPressed: () => setState(
              () {
                _settingsExpanded = !_settingsExpanded;
                _moveSettingsIcon();
              },
            ),
          ),
        ),
      );

  IconData _chooseAccessibilitySwitchIcon() =>
      GeneralAppSettings.isInAccessibilityMode ? Icons.zoom_out : Icons.zoom_in;

  IconData _chooseThemeSwitchIcon() =>
      GeneralAppSettings.currentTheme == ThemeDatas.lightTheme
          ? Icons.nightlight_round
          : Icons.wb_sunny_outlined;

  String _chooseAccessibilitySwitchText() =>
      GeneralAppSettings.isInAccessibilityMode
          ? "Normalny interfejs"
          : "Powiększony interfejs";

  String _chooseThemeSwitchText() =>
      GeneralAppSettings.currentTheme == ThemeDatas.lightTheme
          ? "Tryb ciemny"
          : "Tryb jasny";

  _moveSettingsIcon() {
    _settingsExpanded
        ? _animationController.forward()
        : _animationController.reverse();
  }

  Widget _buildCFABMessageWidget(
    BuildContext context, {
    Animation<Offset> animation,
    IconData iconData,
    String message,
    Function onPress,
    double width,
    int rightContainerFlex = 1,
    bool shouldIncludeRightIndent = false,
  }) {
    return _buildPositionedRightBottom(
      rightIndent: shouldIncludeRightIndent
          ? ComponentSizes.floatingActionButtonSize / 2
          : 0,
      child: SlideTransition(
        position: animation,
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            //color: Colors.purple,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Container(
                  width: width * _rotationAnimation.value,
                  height: ComponentSizes.floatingActionButtonSize,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: Offset(
                          3,
                          3,
                        ),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                    border: Border.all(
                      color: Theme.of(context).accentColor.withOpacity(1),
                      width: 4,
                    ),
                  ),
                ),
                Container(
                  width: width * _animationController.value,
                  height: ComponentSizes.floatingActionButtonSize,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: width * _rotationAnimation.value,
                        height: ComponentSizes.floatingActionButtonSize,
                        padding: EdgeInsets.symmetric(
                          horizontal: Paddings.normal,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.8),
                              Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: onPress,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Icon(
                                  iconData,
                                  size: ComponentSizes.iconSize,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  message,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: rightContainerFlex,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_buildPositionedRightBottom({
  @required Widget child,
  double rightIndent = 0,
}) =>
    Positioned(
      top: 0,
      right: rightIndent,
      bottom: 0,
      child: child,
    );
