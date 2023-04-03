import 'package:ccosvg/constants.dart';
import 'package:ccosvg/models/equal_svg_color_set.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:ccosvg/models/svg_color_change.dart';
import 'package:ccosvg/models/svg_document.dart';
import 'package:ccosvg/widgets/change_color_panel.dart';
import 'package:ccosvg/widgets/checkerboard_panel.dart';
import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  var svgBytes = Uint8List(0);
  List<SvgColor> svgColors = [];
  List<EqualSvgColorSet> svgColorSets = [];
  Set<int> selectedIndices = {};
  bool hasSelection = false;
  String? editingLabel;
  Uint8List? backupSvgBytes;
  List<SvgColor>? backupSvgColors;
  List<EqualSvgColorSet>? backupSvgColorSets;

  @override
  void initState() {
    super.initState();

    svgBytes = widget.svgBytes;
    svgColors = SvgDocument(svgBytes).getColors();
    svgColorSets = summarizeSvgColors(svgColors, 36, 0.1);
    selectedIndices = {};
    hasSelection = false;
    editingLabel = null;
    backupSvgBytes = null;
    backupSvgColors = null;
    backupSvgColorSets = null;
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
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return deviceWidth < deviceHeight
        ? _buildPortraitBody(context, deviceWidth, deviceHeight)
        : _buildLandscapeBody(context, deviceWidth, deviceHeight);
  }

  Widget _buildPortraitBody(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
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
                  child: _buildPaginatedDataTable(context, dataSource)),
              SizedBox(width: double.infinity, height: dataTableHeight, child: _buildChangeColorPanel(context)),
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
                  SvgPicture.memory(SvgDocument(svgBytes).simplified().bytes),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeBody(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
    const appBarHeight = 56;
    final svgViewWidth = deviceWidth * 0.5 - Dimensions.thicknessDivider;
    final svgViewHeight = deviceHeight - appBarHeight;
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: deviceWidth * 0.5,
            height: double.infinity,
            child: Stack(children: [
              SizedBox(
                  width: deviceWidth * 0.5,
                  height: double.infinity,
                  child: _buildPaginatedDataTable(context, dataSource)),
              SizedBox(width: deviceWidth * 0.5, height: double.infinity, child: _buildChangeColorPanel(context)),
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
                  SvgPicture.memory(SvgDocument(svgBytes).simplified().bytes),
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

  Widget _buildPaginatedDataTable(BuildContext context, _HSLColorDataTableSource dataSource) {
    return Visibility(
        child: DataTable2(
          columns: [
            _buildDataColumn(context, "H"),
            _buildDataColumn(context, "S"),
            _buildDataColumn(context, "L"),
            const DataColumn(label: Text("")),
          ],
          onSelectAll: (value) async {
            setState(() {
              selectedIndices = (value ?? false) ? svgColors.asMap().entries.map((e) => e.key).toSet() : {};
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

  DataColumn _buildDataColumn(BuildContext context, String label) {
    final editButtonOrSpace = Visibility(
        child: IconButton(
            iconSize: 18,
            color: Colors.grey[700],
            onPressed: () async {
              setState(() {
                editingLabel = label;
                backupSvgBytes = Uint8List.fromList(svgBytes);
                backupSvgColors = svgColors.map((e) => e.clone()).toList();
                backupSvgColorSets = svgColorSets.map((e) => e.clone()).toList();
              });
            },
            icon: const Icon(Icons.edit)),
        visible: hasSelection,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true);
    return DataColumn(label: Row(children: [Text(label), editButtonOrSpace]));
  }

  Widget _buildChangeColorPanel(BuildContext context) {
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
          svgBytes = Uint8List.fromList(backupSvgBytes ?? Uint8List(0));
          svgColors = (backupSvgColors ?? []).map((e) => e.clone()).toList();
          svgColorSets = (backupSvgColorSets ?? []).map((e) => e.clone()).toList();
          _updateColors(context, change);
        }, onDecided: (change) {
          svgBytes = Uint8List.fromList(backupSvgBytes ?? Uint8List(0));
          svgColors = (backupSvgColors ?? []).map((e) => e.clone()).toList();
          svgColorSets = (backupSvgColorSets ?? []).map((e) => e.clone()).toList();
          _updateColors(context, change);
          setState(() {
            editingLabel = null;
            backupSvgBytes = null;
            backupSvgColors = null;
            backupSvgColorSets = null;
          });
        }, onCancelled: () {
          setState(() {
            svgBytes = backupSvgBytes ?? Uint8List(0);
            svgColors = backupSvgColors ?? [];
            svgColorSets = backupSvgColorSets ?? [];

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

  void _updateColors(BuildContext context, SvgColorChange change) {
    setState(() {
      // Update svgColors
      for (var index in selectedIndices) {
        change.applyToColor(svgColors[index]);
      }

      // Update svgColorSets
      List<EqualSvgColorSet> newSvgColorSets = [];
      for (var svgColorSet in svgColorSets) {
        for (var color in svgColorSet.colors) {
          change.applyToColor(color);
        }
        var newSvgColorSet = EqualSvgColorSet(svgColorSet.colors[0].hslColor, svgColorSet.colors);
        newSvgColorSets.add(newSvgColorSet);
      }
      svgColorSets = newSvgColorSets;

      // Update svgBytes
      final svgDocument = SvgDocument(svgBytes);
      svgDocument.setColors(svgColors);
      svgBytes = svgDocument.bytes;
    });
  }

  void _downloadButtonPressed() {
    FileSaver.instance.saveFile("ccosvg_result.svg", svgBytes, "");
  }
}
