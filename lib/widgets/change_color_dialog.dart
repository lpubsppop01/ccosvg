import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeColorDialog extends StatefulWidget {
  final String label;
  const ChangeColorDialog(this.label, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangeColorDialogState();
}

class _ChangeColorDialogState extends State<ChangeColorDialog> {
  final TextEditingController _textEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Delta of ${_getLongLabel()}"),
        content: TextField(
          controller: _textEditController,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          textAlign: TextAlign.right,
          inputFormatters: [
            TextInputFormatter.withFunction(
                (oldValue, newValue) => RegExp(r"^-?[0-9]*$").hasMatch(newValue.text) ? newValue : oldValue)
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context, int.tryParse(_textEditController.text) ?? 0),
          ),
        ]);
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
