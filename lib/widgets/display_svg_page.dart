import 'package:ccosvg/models/svg_document.dart';
import 'package:ccosvg/widgets/change_color_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplaySvgPage extends StatefulWidget {
  final SvgDocument svgDocument;
  final List<SvgColor> svgColors;
  const DisplaySvgPage(this.svgDocument, this.svgColors, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DisplaySvgPageState();
}

class _HSLColorDataTableSource extends DataTableSource {
  final List<SvgColor> colors;
  final Set<int> selectedIndices;
  final Function(bool?, int) onSelectionChanged;
  _HSLColorDataTableSource(this.colors, this.selectedIndices, this.onSelectionChanged);

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= colors.length) return null;
    final color = colors[index];
    return DataRow.byIndex(
        index: index,
        selected: selectedIndices.contains(index),
        onSelectChanged: (value) => onSelectionChanged(value, index),
        cells: [
          DataCell(Text(color.hslColor.hue.toStringAsFixed(1))),
          DataCell(Text((color.hslColor.saturation * 100).toStringAsFixed(1))),
          DataCell(Text((color.hslColor.lightness * 100).toStringAsFixed(1))),
          DataCell(Text((color.hslColor.alpha * 100).toStringAsFixed(1))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => colors.length;

  @override
  int get selectedRowCount => selectedIndices.length;
}

class _DisplaySvgPageState extends State<DisplaySvgPage> {
  Set<int> selectedIndices = {};
  bool hasSelection = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return deviceWidth < deviceHeight
        ? _buildPortrait(context, deviceWidth, deviceHeight)
        : _buildLandscape(context, deviceWidth, deviceHeight);
  }

  Widget _buildPortrait(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(widget.svgColors, selectedIndices, _onSelectionChanged);
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
                child: SvgPicture.memory(widget.svgDocument.bytes),
              ),
            ])));
  }

  Widget _buildLandscape(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(widget.svgColors, selectedIndices, _onSelectionChanged);
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
                  child: SvgPicture.memory(widget.svgDocument.bytes),
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
        _buildDataColumn(context, "A"),
      ],
      columnSpacing: 14,
      showFirstLastButtons: true,
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
    // TODO
  }
}
