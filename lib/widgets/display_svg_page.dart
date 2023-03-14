import 'dart:typed_data';

import 'package:ccosvg/helpers/hsl_color_with_delta.dart';
import 'package:ccosvg/helpers/show_message.dart';
import 'package:ccosvg/models/equal_svg_color_set.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:ccosvg/models/svg_document.dart';
import 'package:ccosvg/widgets/change_color_dialog.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplaySvgPage extends StatefulWidget {
  final Uint8List svgBytes;
  const DisplaySvgPage(this.svgBytes, {Key? key}) : super(key: key);
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
  int? firstVisibleRowIndex;

  @override
  void initState() {
    super.initState();
    svgBytes = widget.svgBytes;
    svgColors = SvgDocument(svgBytes).getColors();
    svgColorSets = summarizeSvgColors(svgColors, 36, 0.1);
    firstVisibleRowIndex = svgColors.isEmpty ? null : 0;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return deviceWidth < deviceHeight
        ? _buildPortrait(context, deviceWidth, deviceHeight)
        : _buildLandscape(context, deviceWidth, deviceHeight);
  }

  Widget _buildPortrait(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
    final dataTableHeightMax = deviceHeight * 0.5 - 56 - 56 - 56 - 8;
    final dataTableRowsPerPage = (dataTableHeightMax / kMinInteractiveDimension).truncate();
    final dataTableHeight = dataTableRowsPerPage * kMinInteractiveDimension + 56 + 56 + 8;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display SVG"),
        ),
        body: SizedBox(
            width: double.infinity,
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: dataTableHeight,
                child: _buildPaginatedDataTable(context, dataSource, dataTableRowsPerPage),
              ),
              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: Stack(children: [
                  SvgPicture.memory(svgBytes),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: downloadSvgFile, icon: const Icon(Icons.download))),
                ]),
              ),
            ])));
  }

  Widget _buildLandscape(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
    final dataTableHeightMax = deviceHeight - 56 - 56 - 56 - 8;
    final dataTableRowsPerPage = (dataTableHeightMax / kMinInteractiveDimension).truncate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display SVG"),
        ),
        body: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: deviceWidth * 0.5,
                  height: double.infinity,
                  child: _buildPaginatedDataTable(context, dataSource, dataTableRowsPerPage),
                ),
                VerticalDivider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: Stack(children: [
                    SvgPicture.memory(svgBytes),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: downloadSvgFile,
                        icon: const Icon(Icons.download),
                      ),
                    )
                  ]),
                ),
              ],
            )));
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

  PaginatedDataTable _buildPaginatedDataTable(
      BuildContext context, _HSLColorDataTableSource dataSource, int dataTableRowsPerPage) {
    return PaginatedDataTable(
      columns: [
        _buildDataColumn(context, "H"),
        _buildDataColumn(context, "S"),
        _buildDataColumn(context, "L"),
        const DataColumn(label: Text("")),
      ],
      onSelectAll: (value) async {
        final yes = await showYesNo(context, "Select/Deselect All", "Target all items on all pages?");
        if (yes ?? false) {
          setState(() {
            selectedIndices = (value ?? false) ? svgColors.asMap().entries.map((e) => e.key).toSet() : {};
            hasSelection = value ?? false;
          });
        } else {
          setState(() {
            List<int> indices = [];
            final indexStart = firstVisibleRowIndex;
            if (indexStart != null) {
              final indexEnd = indexStart + dataTableRowsPerPage;
              var index = indexStart;
              while (index < indexEnd) {
                indices.add(index);
                ++index;
              }
            }
            if (value ?? false) {
              selectedIndices.addAll(indices);
            } else {
              selectedIndices.removeAll(indices);
            }
            hasSelection = selectedIndices.isNotEmpty;
          });
        }
      },
      columnSpacing: 14,
      showFirstLastButtons: true,
      onPageChanged: (value) {
        setState(() {
          firstVisibleRowIndex = value;
        });
      },
      rowsPerPage: dataTableRowsPerPage,
      source: dataSource,
    );
  }

  DataColumn _buildDataColumn(BuildContext context, String label) {
    final editButtonOrSpace = Visibility(
        child: IconButton(
            iconSize: 18,
            onPressed: () async {
              final delta = await showDialog(context: context, builder: (_) => ChangeColorDialog(label));
              _updateColors(context, label, delta);
            },
            icon: const Icon(Icons.edit)),
        visible: hasSelection,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true);
    return DataColumn(label: Row(children: [Text(label), editButtonOrSpace]));
  }

  void _updateColors(BuildContext context, String label, int delta) {
    setState(() {
      // Update svgColors
      for (var index in selectedIndices) {
        if (label == 'H') {
          svgColors[index].hslColor = svgColors[index].hslColor.withHueDelta(delta);
        } else if (label == 'S') {
          svgColors[index].hslColor = svgColors[index].hslColor.withSaturationDelta(delta / 100.0);
        } else if (label == 'L') {
          svgColors[index].hslColor = svgColors[index].hslColor.withLightnessDelta(delta / 100.0);
        }
      }

      // Update svgBytes
      final svgDocument = SvgDocument(svgBytes);
      svgDocument.setColors(svgColors);
      svgBytes = svgDocument.bytes;
    });
  }

  void downloadSvgFile() {
    FileSaver.instance.saveFile("ccosvg_result.svg", svgBytes, "");
  }
}
