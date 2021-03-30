import 'package:aplikacja_pogodowa/resources/app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:aplikacja_pogodowa/ui/ui.dart';
import 'package:flutter/material.dart';

class WeatherCheckTypeButton extends StatelessWidget {
  final String actionName;
  final Function onPress;
  final IconData categoryIcon;
  final bool isActive;

  const WeatherCheckTypeButton({
    @required this.actionName,
    @required this.onPress,
    this.isActive,
    this.categoryIcon,
  })  : assert(actionName != null),
        assert(onPress != null);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPress,
        child: Stack(
          children: _buildStackedButtonWithChildren(context),
        ),
      );

  List<Widget> _buildStackedButtonWithChildren(BuildContext context) => [
        _buildButtonShadow(context),
        _buildButtonContent(context),
      ];

  Widget _buildButtonShadow2(BuildContext context) => Container(
        width: !GeneralAppSettings.isInAccessibilityMode
            ? ComponentSizes.mainButtonWidth
            : null,
        height: !GeneralAppSettings.isInAccessibilityMode
            ? ComponentSizes.mainButtonHeight
            : null,
        decoration: _buildShadowBoxDecoration(context),
      );

  Widget _buildButtonShadow(BuildContext context) => Container(
        width: _chooseButtonWidth(),
        height: _chooseButtonHeight(),
        decoration: _buildShadowBoxDecoration(context),
      );

  Widget _buildButtonContent(BuildContext context) => Container(
        width: _chooseButtonWidth(),
        height: _chooseButtonHeight(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: _buildMainBoxDecoration(context),
                child: Padding(
                  padding: _chooseMainButtonPadding(),
                  child: _buildButtonChildrenRow(),
                ),
              ),
            ),
          ],
        ),
      );

  double _chooseButtonWidth() => GeneralAppSettings.isInAccessibilityMode
      ? ComponentSizes.mainButtonAcWidth
      : ComponentSizes.mainButtonWidth;

  double _chooseButtonHeight() => GeneralAppSettings.isInAccessibilityMode
      ? ComponentSizes.mainButtonAcHeight
      : ComponentSizes.mainButtonHeight;

  EdgeInsetsGeometry _chooseMainButtonPadding() =>
      GeneralAppSettings.isInAccessibilityMode
          ? const EdgeInsets.symmetric(
              horizontal: Paddings.big,
            )
          : const EdgeInsets.all(Paddings.normal);

  BoxDecoration _buildShadowBoxDecoration(BuildContext context) =>
      BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.12),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(3, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _chooseBorderColor(context),
          width: 4,
        ),
      );

  Color _chooseBorderColor(BuildContext context) {
    if (isActive == null) {
      return Theme.of(context).accentColor.withOpacity(1);
    } else if (isActive) {
      return Theme.of(context).accentColor.withOpacity(1);
    } else {
      return Theme.of(context).accentColor.withOpacity(0.1);
    }
  }

  BoxDecoration _buildMainBoxDecoration(BuildContext context) => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _buildUpperGradientColor(context),
            _buildLowerGradientColor(context),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      );

  Color _buildUpperGradientColor(BuildContext context) {
    if (isActive == null) {
      return Theme.of(context).primaryColor.withOpacity(0.8);
    } else if (isActive) {
      return Theme.of(context).primaryColor.withOpacity(0.9);
    } else {
      return Theme.of(context).primaryColor.withOpacity(0);
    }
  }

  Color _buildLowerGradientColor(BuildContext context) {
    if (isActive == null) {
      return Theme.of(context).backgroundColor.withOpacity(0.9);
    } else if (isActive) {
      return Theme.of(context).backgroundColor.withOpacity(0.9);
    } else {
      return Theme.of(context).backgroundColor.withOpacity(0);
    }
  }

  Row _buildButtonChildrenRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryIcon(),
          _buildButtonText(),
          _buildRightFreeSpace(),
        ],
      );

  Widget _buildCategoryIcon() => Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => Icon(
            categoryIcon,
            size: constraints.biggest.width,
          ),
        ),
      );

  Widget _buildButtonText() => Expanded(
        flex: 3,
        child: Text(
          actionName,
          textAlign: TextAlign.center,
          style: GeneralAppSettings.isInAccessibilityMode
              ? TextStyles.normalAc
              : TextStyles.normal,
        ),
      );

  Widget _buildRightFreeSpace() => Expanded(
        child: Container(),
      );
}
