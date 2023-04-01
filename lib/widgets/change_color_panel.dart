import 'package:ccosvg/constants.dart';
import 'package:ccosvg/models/svg_color_change.dart';
import 'package:ccosvg/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeColorPanel extends StatefulWidget {
  final SvgColorChangeTargetComponent targetComponent;
  final Function(SvgColorChange change)? onChanged;
  final Function(SvgColorChange change)? onDecided;
  final Function? onCancelled;
  const ChangeColorPanel(this.targetComponent, {this.onChanged, this.onDecided, this.onCancelled, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangeColorPanelState();
}

class _ChangeColorPanelState extends State<ChangeColorPanel> {
  final TextEditingController _textEditController = TextEditingController();
  SvgColorChangeDeltaKind _deltaKind = SvgColorChangeDeltaKind.value;
  List<bool> _selectedDeltaKinds = [];

  @override
  void initState() {
    super.initState();

    _textEditController.addListener(textEditControllerChanged);
    _textEditController.text = "0";
    _selectedDeltaKinds = List.generate(
      SvgColorChangeDeltaKind.values.length,
      (index) => SvgColorChangeDeltaKind.values[index] == _deltaKind,
    );
  }

  @override
  Widget build(BuildContext context) {
    const spacingAddButtons = 5.0;
    final addButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.only(left: 10, right: 10),
      minimumSize: const Size(0, 40),
    );
    return SizedBox(
      width: double.infinity,
      child: Column(children: [
        SizedBox(
            width: double.infinity,
            height: Dimensions.heightNaviBar,
            child: Stack(children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Edit ${_getLongLabel()}",
                  style: const TextStyle(fontSize: Dimensions.fontSizeNormal),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginNaviLeft),
                  child: IconButton(
                    color: Colors.grey[700],
                    onPressed: () => widget.onCancelled?.call(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: Dimensions.marginNaviRight),
                  child: IconButton(
                    color: Colors.grey[700],
                    onPressed: () => widget.onDecided?.call(_buildChange()),
                    icon: const Icon(Icons.check),
                  ),
                ),
              ),
            ])),
        Divider(
          color: Theme.of(context).dividerColor,
          thickness: Dimensions.thicknessDivider,
          height: Dimensions.thicknessDivider,
        ),
        Container(
          margin: Dimensions.marginBodyLTR,
          child: Row(children: [
            ToggleButtons(
              children: const [
                Icon(MyFlutterApp.color_change_delta_kind_0, size: 40),
                Icon(MyFlutterApp.color_change_delta_kind_1, size: 40),
              ],
              isSelected: _selectedDeltaKinds,
              onPressed: _deltaKindToggleButtonsPressed,
              constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
              color: Colors.grey[600],
              selectedColor: Colors.white,
              fillColor: Colors.grey[700],
              borderColor: Colors.grey[700],
              selectedBorderColor: Colors.grey[700],
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
          ]),
        ),
        Container(
            margin: Dimensions.marginBodyLTR,
            child: TextField(
              controller: _textEditController,
              decoration: InputDecoration(
                suffixText: _deltaKind == SvgColorChangeDeltaKind.percentageInLimit ?  '%' : '',
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.right,
              inputFormatters: [
                TextInputFormatter.withFunction(
                    (oldValue, newValue) => RegExp(r"^-?[0-9]*$").hasMatch(newValue.text) ? newValue : oldValue)
              ],
            )),
        Visibility(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: Dimensions.marginBodyLTR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: const Text("-10"),
                    onPressed: () => addValueButtonPressed(-10),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("-1"),
                    onPressed: () => addValueButtonPressed(-1),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("+1"),
                    onPressed: () => addValueButtonPressed(1),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("+10"),
                    onPressed: () => addValueButtonPressed(10),
                    style: addButtonStyle,
                  ),
                ],
              ),
            ),
          ),
          visible: _deltaKind == SvgColorChangeDeltaKind.value,
        ),
        Visibility(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: Dimensions.marginBodyLTR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: const Text("-10%"),
                    onPressed: () => addValueButtonPressed(-10),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("-1%"),
                    onPressed: () => addValueButtonPressed(-1),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("+1%"),
                    onPressed: () => addValueButtonPressed(1),
                    style: addButtonStyle,
                  ),
                  const SizedBox(width: spacingAddButtons),
                  ElevatedButton(
                    child: const Text("+10%"),
                    onPressed: () => addValueButtonPressed(10),
                    style: addButtonStyle,
                  ),
                ],
              ),
            ),
          ),
          visible: _deltaKind == SvgColorChangeDeltaKind.percentageInLimit,
        ),
      ]),
    );
  }

  String _getLongLabel() {
    switch (widget.targetComponent) {
      case SvgColorChangeTargetComponent.hue:
        return "Hue";
      case SvgColorChangeTargetComponent.saturation:
        return "Saturation";
      case SvgColorChangeTargetComponent.lightness:
        return "Lightness";
      default:
        return "";
    }
  }

  SvgColorChange _buildChange() {
    var delta = int.tryParse(_textEditController.text) ?? 0;
    var change = SvgColorChange(
      widget.targetComponent,
      _deltaKind,
      delta,
    );
    return change;
  }

  void textEditControllerChanged() {
    widget.onChanged?.call(_buildChange());
  }

  void _deltaKindToggleButtonsPressed(int index) {
    setState(() {
      _deltaKind = SvgColorChangeDeltaKind.values[index];
      _selectedDeltaKinds = List.generate(
        SvgColorChangeDeltaKind.values.length,
        (index) => SvgColorChangeDeltaKind.values[index] == _deltaKind,
      );
    });
    widget.onChanged?.call(_buildChange());
  }

  void addValueButtonPressed(int valueToAdd) {
    var currentValue = int.tryParse(_textEditController.text) ?? 0;
    var addedValue = currentValue + valueToAdd;
    _textEditController.text = addedValue.toString();
  }
}
