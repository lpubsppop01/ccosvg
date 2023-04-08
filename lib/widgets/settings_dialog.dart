import 'dart:math';

import 'package:ccosvg/models/settings_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SettingsDialog extends StatefulWidget {
  final Function(SettingsChange change)? onChanged;
  const SettingsDialog({this.onChanged, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<double> _toleranceDegree;
  late Future<double> _toleranceRatio;
  final TextEditingController _toleranceDegreeTextEditController = TextEditingController();
  final TextEditingController _toleranceRatioTextEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _toleranceDegree = _prefs
        .then((prefs) => prefs.getDouble('toleranceDegree') ?? SettingsDefault.toleranceDegree)
        .onError((error, stackTrace) => SettingsDefault.toleranceDegree);
    _toleranceRatio = _prefs
        .then((prefs) => prefs.getDouble('toleranceRatio') ?? SettingsDefault.toleranceRatio)
        .onError((error, stackTrace) => SettingsDefault.toleranceRatio);
    _toleranceDegreeTextEditController.addListener(_toleranceDegreeTextEditControllerChanged);
    _toleranceRatioTextEditController.addListener(_toleranceRatioTextEditControllerChanged);
  }

  @override
  Widget build(BuildContext context) {
    const spacingAddButtons = 5.0;
    final addButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      minimumSize: const Size(0, 0),
      fixedSize: const Size(40, 40),
    );
    return AlertDialog(
        title: const Text("Settings"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Tolerance for Equivalence of Hue"),
          ),
          const SizedBox(height: Dimensions.spacingBodyHalf),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<double>(
                  future: _toleranceDegree,
                  builder: (context, snapshot) {
                    final toleranceDegree = snapshot.data;
                    if (toleranceDegree != null) {
                      _toleranceDegreeTextEditController.text = toleranceDegree.toString();
                      return TextField(
                        controller: _toleranceDegreeTextEditController,
                        decoration: const InputDecoration(
                          suffixText: 'deg',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          TextInputFormatter.withFunction(
                              (oldValue, newValue) => RegExp(r"^[0-9]*$").hasMatch(newValue.text) ? newValue : oldValue)
                        ],
                      );
                    } else {
                      return const TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.right,
                        //enabled: false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: Dimensions.spacingBody),
              ElevatedButton(
                child: const Text("-1"),
                onPressed: () => _addToleranceDegreeButtonPressed(-1),
                style: addButtonStyle,
              ),
              const SizedBox(width: spacingAddButtons),
              ElevatedButton(
                child: const Text("+1"),
                onPressed: () => _addToleranceDegreeButtonPressed(1),
                style: addButtonStyle,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.spacingBody),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Tolerance for Equivalence of Saturation and Lightness"),
          ),
          const SizedBox(height: Dimensions.spacingBodyHalf),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<double>(
                  future: _toleranceRatio,
                  builder: (context, snapshot) {
                    final toleranceRatio = snapshot.data;
                    if (toleranceRatio != null) {
                      _toleranceRatioTextEditController.text = toleranceRatio.toString();
                      return TextField(
                        controller: _toleranceRatioTextEditController,
                        decoration: const InputDecoration(
                          suffixText: '%',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) =>
                              RegExp(r"^-?[0-9]*$").hasMatch(newValue.text) ? newValue : oldValue)
                        ],
                      );
                    } else {
                      return const TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.right,
                        //enabled: false,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: Dimensions.spacingBody),
              ElevatedButton(
                child: const Text("-1"),
                onPressed: () => _addToleranceRatioButtonPressed(-1),
                style: addButtonStyle,
              ),
              const SizedBox(width: spacingAddButtons),
              ElevatedButton(
                child: const Text("+1"),
                onPressed: () => _addToleranceRatioButtonPressed(1),
                style: addButtonStyle,
              ),
            ],
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ]);
  }

  void _toleranceDegreeTextEditControllerChanged() async {
    final newValue = int.tryParse(_toleranceDegreeTextEditController.text) ?? 0;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("toleranceDegree", newValue as double);
    final change = SettingsChange(SettingsChangeTarget.toleranceDegree, newValue);
    widget.onChanged?.call(change);
  }

  void _toleranceRatioTextEditControllerChanged() async {
    final newValue = int.tryParse(_toleranceRatioTextEditController.text) ?? 0;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble("toleranceRatio", newValue as double);
    final change = SettingsChange(SettingsChangeTarget.toleranceRatio, newValue);
    widget.onChanged?.call(change);
  }

  void _addToleranceDegreeButtonPressed(int valueToAdd) {
    var currentValue = int.tryParse(_toleranceDegreeTextEditController.text) ?? 0;
    var addedValue = max(0, currentValue + valueToAdd);
    _toleranceDegreeTextEditController.text = addedValue.toString();
  }

  void _addToleranceRatioButtonPressed(int valueToAdd) {
    var currentValue = int.tryParse(_toleranceRatioTextEditController.text) ?? 0;
    var addedValue = max(0, currentValue + valueToAdd);
    _toleranceRatioTextEditController.text = addedValue.toString();
  }
}
