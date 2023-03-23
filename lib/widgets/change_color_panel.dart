import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeColorPanel extends StatefulWidget {
  final String label;
  final Function(int value)? onChanged;
  final Function(int value)? onDecided;
  final Function? onCancelled;
  const ChangeColorPanel(this.label, {this.onChanged, this.onDecided, this.onCancelled, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangeColorPanelState();
}

class _ChangeColorPanelState extends State<ChangeColorPanel> {
  final TextEditingController _textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textEditController.addListener(() {
      widget.onChanged?.call(int.tryParse(_textEditController.text) ?? 0);
    });
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
                  onPressed: () => widget.onDecided?.call(int.tryParse(_textEditController.text) ?? 0),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  String _getLongLabel() {
    switch (widget.label) {
      case "H":
        return "Hue";
      case "S":
        return "Saturation";
      case "L":
        return "Lightness";
      default:
        return widget.label;
    }
  }
}
