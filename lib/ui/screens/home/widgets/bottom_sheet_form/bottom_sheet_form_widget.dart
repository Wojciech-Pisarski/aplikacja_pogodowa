import 'package:aplikacja_pogodowa/enums/enums.dart';
import 'package:aplikacja_pogodowa/resources/app_settings/app_settings.dart';
import 'package:aplikacja_pogodowa/ui/screens/home/widgets/bottom_sheet_form/bottom_sheet_form_dto.dart';
import 'package:aplikacja_pogodowa/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetFormWidget extends StatefulWidget {
  final Function(Map<WeatherDataInputType, String>) onPressContinue;
  final String title;
  final List<BottomSheetFormDto> bottomSheetFormWidgetDtoList;

  BottomSheetFormWidget({
    @required this.onPressContinue,
    @required this.title,
    @required this.bottomSheetFormWidgetDtoList,
  })  : assert(onPressContinue != null),
        assert(title != null),
        assert(bottomSheetFormWidgetDtoList != null);

  @override
  _BottomSheetFormWidgetState createState() => _BottomSheetFormWidgetState();
}

class _BottomSheetFormWidgetState extends State<BottomSheetFormWidget> {
  TextEditingController textEditingController = TextEditingController();
  List<TextEditingController> listOfControllers = [];
  bool isSaveButtonOn = false;

  @override
  void initState() {
    _initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    listOfControllers.every((element) {
      element.dispose();
      return true;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(Paddings.normal),
          decoration: _buildBottomSheetDecoration(context),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildFormsTitle(),
              Form(
                child: _buildFormsRow(),
              ),
              Center(
                child: _buildFormsAcceptButtonWithPadding(context),
              ),
            ],
          ),
        ),
      );

  _initializeControllers() {
    for (int i = 0; i < widget.bottomSheetFormWidgetDtoList.length; i++) {
      final controller = TextEditingController();
      final dto = widget.bottomSheetFormWidgetDtoList[i];
      listOfControllers.add(controller);
      controller.addListener(() => (dto.isNumericValue)
          ? _numericalControllersConditions(dto, controller)
          : _textControllerConditions());
    }
  }

  _numericalControllersConditions(
    BottomSheetFormDto dto,
    TextEditingController controller,
  ) {
    var controllerTextToDouble = double.tryParse(controller.text);
    if (controllerTextToDouble != null) {
      if (controllerTextToDouble > dto.upperBound) {
        controller.text = dto.upperBound.toString();
      } else if (controllerTextToDouble < dto.lowerBound) {
        controller.text = dto.lowerBound.toString();
      }
      listOfControllers
              .every((element) => double.tryParse(element.text) != null)
          ? _enableSaveButton(true)
          : _enableSaveButton(false);
    } else {
      _enableSaveButton(false);
    }
  }

  _textControllerConditions() =>
      listOfControllers.every((element) => element.text.trim().isNotEmpty)
          ? _enableSaveButton(true)
          : _enableSaveButton(false);

  _enableSaveButton(bool enable) {
    if (enable && !isSaveButtonOn) {
      setState(() {
        isSaveButtonOn = true;
      });
    } else if (!enable && isSaveButtonOn) {
      setState(() {
        isSaveButtonOn = false;
      });
    }
  }

  BoxDecoration _buildBottomSheetDecoration(BuildContext context) =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Theme.of(context).backgroundColor.withOpacity(0.9),
            Theme.of(context).primaryColor.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      );

  Widget _buildFormsTitle() => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Paddings.huge,
        ),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyles.h2,
        ),
      );

  Row _buildFormsRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildFormsRowChildren(),
      );

  List<Widget> _buildFormsRowChildren() {
    final List<Widget> forms = [];
    for (int i = 0; i < widget.bottomSheetFormWidgetDtoList.length; i++) {
      var element = widget.bottomSheetFormWidgetDtoList[i];
      forms.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Paddings.normal,
            ),
            child: TextField(
              controller: listOfControllers[i],
              keyboardType: element.isNumericValue
                  ? TextInputType.numberWithOptions(
                      decimal: true,
                    )
                  : TextInputType.text,
              decoration: InputDecoration(
                hoverColor: Colors.blue,
                fillColor: Colors.blue,
                focusColor: Colors.blue,
                labelText: element.label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return forms;
  }

  Widget _buildFormsAcceptButtonWithPadding(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          top: Paddings.huge,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GeneralAppSettings.isInAccessibilityMode
            ? Container(
                width: ComponentSizes.mainButtonWidth,
                height: ComponentSizes.mainButtonHeight,
                child: _buildFormsAcceptButton(),
              )
            : _buildFormsAcceptButton(),
      );

  Widget _buildFormsAcceptButton() => WeatherCheckTypeButton(
        onPress: _chooseFormsAcceptButtonFunction,
        actionName: "Sprawdź pogodę",
        isActive: isSaveButtonOn,
      );

  _chooseFormsAcceptButtonFunction() {
    if (isSaveButtonOn) {
      Map<WeatherDataInputType, String> bottomSheetFormOutput = {};
      if (widget.bottomSheetFormWidgetDtoList
          .every((element) => element.isNumericValue)) {
        int longitudeControllerIndex = widget.bottomSheetFormWidgetDtoList
            .indexWhere((element) =>
                element.weatherDataInputType == WeatherDataInputType.LONGITUDE);
        int latitudeControllerIndex = widget.bottomSheetFormWidgetDtoList
            .indexWhere((element) =>
                element.weatherDataInputType == WeatherDataInputType.LATITUDE);
        bottomSheetFormOutput[WeatherDataInputType.LONGITUDE] =
            listOfControllers[longitudeControllerIndex].text.trim();
        bottomSheetFormOutput[WeatherDataInputType.LATITUDE] =
            listOfControllers[latitudeControllerIndex].text.trim();
      } else if (widget.bottomSheetFormWidgetDtoList
          .every((element) => !element.isNumericValue)) {
        int cityNameControllerIndex = widget.bottomSheetFormWidgetDtoList
            .indexWhere((element) =>
                element.weatherDataInputType == WeatherDataInputType.CITY_NAME);
        bottomSheetFormOutput[WeatherDataInputType.CITY_NAME] =
            listOfControllers[cityNameControllerIndex].text.trim();
      }
      return widget.onPressContinue(bottomSheetFormOutput);
    }
  }
}
