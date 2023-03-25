import 'package:ccosvg/models/svg_color_change.dart';
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

  @override
  void initState() {
    super.initState();

    _textEditController.addListener(textEditControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(children: [
        SizedBox(
            width: double.infinity,
            child: Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text("Delta of ${_getLongLabel()}",
                    style: const TextStyle(
                      fontSize: 18,
                    )))),
        Column(children: [
          RadioListTile(
            title: const Text("Value"),
            value: SvgColorChangeDeltaKind.value,
            groupValue: _deltaKind,
            onChanged: deltaKindRadioChanged,
          ),
          RadioListTile(
            title: const Text("Percentage in Limit"),
            value: SvgColorChangeDeltaKind.percentageInLimit,
            groupValue: _deltaKind,
            onChanged: deltaKindRadioChanged,
          ),
        ]),
        Visibility(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: const Text("-10"),
                    onPressed: () => addValueButtonPressed(-10),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("-1"),
                    onPressed: () => addValueButtonPressed(-1),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("+1"),
                    onPressed: () => addValueButtonPressed(1),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("+10"),
                    onPressed: () => addValueButtonPressed(10),
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
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    child: const Text("-25"),
                    onPressed: () => addValueButtonPressed(-25),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("-10"),
                    onPressed: () => addValueButtonPressed(-10),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("+10"),
                    onPressed: () => addValueButtonPressed(10),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text("+25"),
                    onPressed: () => addValueButtonPressed(25),
                  ),
                ],
              ),
            ),
          ),
          visible: _deltaKind == SvgColorChangeDeltaKind.percentageInLimit,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              controller: _textEditController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              textAlign: TextAlign.right,
              inputFormatters: [
                TextInputFormatter.withFunction(
                    (oldValue, newValue) => RegExp(r"^-?[0-9]*$").hasMatch(newValue.text) ? newValue : oldValue)
              ],
            )),
        SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () => widget.onCancelled?.call(),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    widget.onDecided?.call(_buildChange());
                  },
                ),
              ],
            ),
          ),
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

  void deltaKindRadioChanged(Object? value) {
    if (value is! SvgColorChangeDeltaKind) return;
    setState(() {
      _deltaKind = value;
    });
    widget.onChanged?.call(_buildChange());
  }

  void addValueButtonPressed(int valueToAdd) {
    var currentValue = int.tryParse(_textEditController.text) ?? 0;
    var addedValue = currentValue + valueToAdd;
    _textEditController.text = addedValue.toString();
  }
}
