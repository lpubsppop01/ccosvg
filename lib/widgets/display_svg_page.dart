import 'package:ccosvg/constants.dart';
import 'package:ccosvg/models/equal_svg_color_set.dart';
import 'package:ccosvg/models/settings_change.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:ccosvg/models/svg_color_change.dart';
import 'package:ccosvg/models/svg_document.dart';
import 'package:ccosvg/widgets/change_color_panel.dart';
import 'package:ccosvg/widgets/checkerboard_panel.dart';
import 'package:ccosvg/widgets/settings_dialog.dart';
import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySvgPage extends StatefulWidget {
  final String svgName;
  final Uint8List svgBytes;
  const DisplaySvgPage(this.svgName, this.svgBytes, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DisplaySvgPageState();
}

class _HSLColorDataTableSource extends DataTableSource {
  final List<EqualSvgColorSet> colorSets;
  final Set<int> selectedIndices;
  final Function(bool?, int) onSelectionChanged;
  _HSLColorDataTableSource(this.colorSets, this.selectedIndices, this.onSelectionChanged);

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= colorSets.length) return null;
    final colorSet = colorSets[index];
    final hslColor = colorSet.representingValue;
    return DataRow.byIndex(
        index: index,
        selected: selectedIndices.contains(index),
        onSelectChanged: (value) => onSelectionChanged(value, index),
        cells: [
          DataCell(Text(hslColor.hue.toStringAsFixed(1))),
          DataCell(Text((hslColor.saturation * 100).toStringAsFixed(1))),
          DataCell(Text((hslColor.lightness * 100).toStringAsFixed(1))),
          DataCell(Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: hslColor.toColor(),
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(2),
              ))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => colorSets.length;

  @override
  int get selectedRowCount => selectedIndices.length;
}

class _DisplaySvgPageState extends State<DisplaySvgPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _svgBytes = Uint8List(0);
  late Future<List<EqualSvgColorSet>> _colorSets;
  Set<int> selectedIndices = {};
  bool hasSelection = false;
  String? editingLabel;
  Uint8List? backupSvgBytes;
  List<SvgColor>? backupSvgColors;
  List<EqualSvgColorSet>? backupSvgColorSets;

  @override
  void initState() {
    super.initState();

    _svgBytes = widget.svgBytes;
    _colorSets = _prefs.then((prefs) {
      final toleranceDegree = prefs.getDouble("toleranceDegree") ?? SettingsDefault.toleranceDegree;
      final toleranceRatio = (prefs.getDouble("toleranceRatio") ?? SettingsDefault.toleranceRatio) / 100.0;
      return _createColorSets(toleranceDegree, toleranceRatio);
    }).onError((error, stackTrace) {
      const toleranceDegree = SettingsDefault.toleranceDegree;
      const toleranceRatio = SettingsDefault.toleranceRatio / 100.0;
      return _createColorSets(toleranceDegree, toleranceRatio);
    });
    selectedIndices = {};
    hasSelection = false;
    editingLabel = null;
    backupSvgBytes = null;
    backupSvgColors = null;
    backupSvgColorSets = null;
  }

  List<EqualSvgColorSet> _createColorSets(double toleranceDegree, double toleranceRatio) {
    final svgColors = SvgDocument(_svgBytes).getColors();
    final svgColorSets = summarizeSvgColors(svgColors, toleranceDegree, toleranceRatio)
        .sorted((a, b) => -a.compareKeyTo(b)); // descending
    return svgColorSets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.svgName),
        actions: [
          IconButton(
            onPressed: _downloadButtonPressed,
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: settingsButtonPressed,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<EqualSvgColorSet>>(
      future: _colorSets,
      builder: (context, snapshot) {
        final colorSets = snapshot.data;
        if (colorSets != null) {
          final double deviceWidth = MediaQuery.of(context).size.width;
          final double deviceHeight = MediaQuery.of(context).size.height;
          return deviceWidth < deviceHeight
              ? _buildPortraitBody(context, deviceWidth, deviceHeight, colorSets)
              : _buildLandscapeBody(context, deviceWidth, deviceHeight, colorSets);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text("Loading..."),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPortraitBody(
      BuildContext context, double deviceWidth, double deviceHeight, List<EqualSvgColorSet> colorSets) {
    final dataSource = _HSLColorDataTableSource(colorSets, selectedIndices, _onSelectionChanged);
    const appBarHeight = 56;
    const dataTableHeaderHeight = 56;
    final dataTableHeightMax = (deviceHeight - appBarHeight) * 0.5 - dataTableHeaderHeight;
    final dataTableRowsPerPage = (dataTableHeightMax / kMinInteractiveDimension).truncate();
    final dataTableHeight = (dataTableRowsPerPage + 0.5) * kMinInteractiveDimension + dataTableHeaderHeight;
    final svgViewHeight = deviceHeight - appBarHeight - dataTableHeight - Dimensions.thicknessDivider;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: dataTableHeight,
                  child: _buildPaginatedDataTable(context, dataSource, colorSets)),
              SizedBox(
                  width: double.infinity,
                  height: dataTableHeight,
                  child: _buildChangeColorPanel(context, colorSets)),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: Dimensions.thicknessDivider,
            height: Dimensions.thicknessDivider,
          ),
          SizedBox(
            width: deviceWidth,
            child: SingleChildScrollView(
              child: SizedBox(
                width: deviceWidth,
                height: svgViewHeight,
                child: Stack(children: [
                  CheckerboardPanel(25, Colors.black12, Colors.black38),
                  SvgPicture.memory(SvgDocument(_svgBytes).simplified().bytes),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeBody(
      BuildContext context, double deviceWidth, double deviceHeight, List<EqualSvgColorSet> colorSets) {
    final dataSource = _HSLColorDataTableSource(colorSets, selectedIndices, _onSelectionChanged);
    const double appBarHeight = 56;
    const double dataTableWidth = 350;
    final svgViewWidth = deviceWidth - dataTableWidth - Dimensions.thicknessDivider;
    final svgViewHeight = deviceHeight - appBarHeight;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: dataTableWidth,
            height: double.infinity,
            child: Stack(children: [
              SizedBox(
                  width: dataTableWidth,
                  height: double.infinity,
                  child: _buildPaginatedDataTable(context, dataSource, colorSets)),
              SizedBox(
                  width: dataTableWidth,
                  height: double.infinity,
                  child: _buildChangeColorPanel(context, colorSets)),
            ]),
          ),
          VerticalDivider(
            color: Theme.of(context).dividerColor,
            thickness: Dimensions.thicknessDivider,
            width: Dimensions.thicknessDivider,
          ),
          SizedBox(
            width: svgViewWidth,
            height: double.infinity,
            child: SingleChildScrollView(
              child: SizedBox(
                width: svgViewWidth,
                height: svgViewHeight,
                child: Stack(children: [
                  CheckerboardPanel(25, Colors.black12, Colors.black38),
                  SvgPicture.memory(SvgDocument(_svgBytes).simplified().bytes),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectionChanged(bool? value, int index) {
    setState(() {
      if (value ?? false) {
        selectedIndices.add(index);
      } else {
        selectedIndices.remove(index);
      }
      hasSelection = selectedIndices.isNotEmpty;
    });
  }

  Widget _buildPaginatedDataTable(
      BuildContext context, _HSLColorDataTableSource dataSource, List<EqualSvgColorSet> colorSets) {
    return Visibility(
        child: DataTable2(
          columns: [
            _buildDataColumn(context, "H", colorSets),
            _buildDataColumn(context, "S", colorSets),
            _buildDataColumn(context, "L", colorSets),
            const DataColumn(label: Text("")),
          ],
          onSelectAll: (value) async {
            setState(() {
              selectedIndices = (value ?? false) ? colorSets.asMap().entries.map((e) => e.key).toSet() : {};
              hasSelection = value ?? false;
            });
          },
          columnSpacing: 14,
          rows: List.generate(dataSource.rowCount, (index) => index)
              .map((i) => dataSource.getRow(i))
              .whereNotNull()
              .toList(),
        ),
        visible: editingLabel == null);
  }

  DataColumn _buildDataColumn(BuildContext context, String label, List<EqualSvgColorSet> colorSets) {
    final editButtonOrSpace = Visibility(
        child: IconButton(
            iconSize: 18,
            color: Colors.grey[700],
            onPressed: () async {
              setState(() {
                editingLabel = label;
                backupSvgBytes = Uint8List.fromList(_svgBytes);
                backupSvgColorSets = colorSets.map((e) => e.clone()).toList();
              });
            },
            icon: const Icon(Icons.edit)),
        visible: hasSelection,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true);
    return DataColumn(label: Row(children: [Text(label), editButtonOrSpace]));
  }

  Widget _buildChangeColorPanel(BuildContext context, List<EqualSvgColorSet> colorSets) {
    var targetComponent = SvgColorChangeTargetComponent.hue;
    switch (editingLabel ?? "") {
      case "H":
        targetComponent = SvgColorChangeTargetComponent.hue;
        break;
      case "S":
        targetComponent = SvgColorChangeTargetComponent.saturation;
        break;
      case "L":
        targetComponent = SvgColorChangeTargetComponent.lightness;
        break;
    }
    return Visibility(
      child: SingleChildScrollView(
        child: ChangeColorPanel(targetComponent, onChanged: (change) {
          _svgBytes = Uint8List.fromList(backupSvgBytes ?? Uint8List(0));
          colorSets.clear();
          colorSets.addAll((backupSvgColorSets ?? []).map((e) => e.clone()));
          _applyColorChange(context, change, colorSets);
        }, onDecided: (change) {
          _svgBytes = Uint8List.fromList(backupSvgBytes ?? Uint8List(0));
          colorSets.clear();
          colorSets.addAll((backupSvgColorSets ?? []).map((e) => e.clone()));
          _applyColorChange(context, change, colorSets);
          setState(() {
            editingLabel = null;
            backupSvgBytes = null;
            backupSvgColors = null;
            backupSvgColorSets = null;
          });
        }, onCancelled: () {
          setState(() {
            _svgBytes = backupSvgBytes ?? Uint8List(0);
            colorSets.clear();
            colorSets.addAll(backupSvgColorSets ?? []);

            editingLabel = null;
            backupSvgBytes = null;
            backupSvgColors = null;
            backupSvgColorSets = null;
          });
        }),
      ),
      visible: editingLabel != null,
    );
  }

  void _applyColorChange(BuildContext context, SvgColorChange change, List<EqualSvgColorSet> colorSets) {
    setState(() {
      // Update svgColorSets
      List<EqualSvgColorSet> newColorSets = [];
      for (var index = 0; index < colorSets.length; ++index) {
        final newColors = colorSets[index].colors.map((e) => e.clone()).toList();
        if (selectedIndices.contains(index)) {
          for (var newColor in newColors) {
            change.applyToColor(newColor);
          }
        }
        var newColorSet = EqualSvgColorSet(newColors[0].hslColor, newColors);
        newColorSets.add(newColorSet);
      }
      colorSets.clear();
      colorSets.addAll(newColorSets);

      // Update svgBytes
      final svgDocument = SvgDocument(_svgBytes);
      svgDocument.setColors(colorSets.expand((element) => element.colors).toList());
      _svgBytes = svgDocument.bytes;
    });
  }

  void _downloadButtonPressed() {
    FileSaver.instance.saveFile("ccosvg_result.svg", _svgBytes, "");
  }

  void settingsButtonPressed() async {
    final _ = await showDialog(
      context: context,
      builder: (_) => SettingsDialog(
        onChanged: (change) {
          setState(() {
            _colorSets = _prefs.then((prefs) {
              var toleranceDegree = prefs.getDouble("toleranceDegree") ?? SettingsDefault.toleranceDegree;
              var toleranceRatio = (prefs.getDouble("toleranceRatio") ?? SettingsDefault.toleranceRatio) / 100.0;
              if (change.target == SettingsChangeTarget.toleranceDegree) {
                toleranceDegree = change.newValue as double;
              } else if (change.target == SettingsChangeTarget.toleranceRatio) {
                toleranceRatio = (change.newValue as double) / 100.0;
              }
              return _createColorSets(toleranceDegree, toleranceRatio);
            });
          });
        },
      ),
    );
  }
}
