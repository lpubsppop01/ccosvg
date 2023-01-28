import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplaySvgPage extends StatefulWidget {
  final Uint8List svgBytes;
  final List<HSLColor> svgColors = [
    HSLColor.fromColor(Colors.red),
    HSLColor.fromColor(Colors.green),
    HSLColor.fromColor(Colors.blue),
    HSLColor.fromColor(Colors.red),
    HSLColor.fromColor(Colors.green),
    HSLColor.fromColor(Colors.blue),
    HSLColor.fromColor(Colors.red),
    HSLColor.fromColor(Colors.green),
    HSLColor.fromColor(Colors.blue),
    HSLColor.fromColor(Colors.red),
    HSLColor.fromColor(Colors.green),
    HSLColor.fromColor(Colors.blue),
  ];
  DisplaySvgPage(this.svgBytes, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DisplaySvgPageState();
}

class _HSLColorDataTableSource extends DataTableSource {
  List<HSLColor> colors;
  _HSLColorDataTableSource(this.colors);

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= colors.length) return null;
    final color = colors[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(color.hue.toStringAsFixed(1))),
      DataCell(Text((color.saturation * 100).toStringAsFixed(1))),
      DataCell(Text((color.lightness * 100).toStringAsFixed(1))),
      DataCell(Text((color.alpha * 100).toStringAsFixed(1))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => colors.length;

  @override
  int get selectedRowCount => 0;
}

class _DisplaySvgPageState extends State<DisplaySvgPage> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return deviceWidth < deviceHeight
        ? _buildPortrait(context, deviceWidth, deviceHeight)
        : _buildLandscape(context, deviceWidth, deviceHeight);
  }

  Widget _buildPortrait(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(widget.svgColors);
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
                child: _buildPaginatedDataTable(dataSource, dataTableRowsPerPage),
              ),
              Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: SvgPicture.memory(widget.svgBytes),
              ),
            ])));
  }

  Widget _buildLandscape(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(widget.svgColors);
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
                  child: _buildPaginatedDataTable(dataSource, dataTableRowsPerPage),
                ),
                VerticalDivider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: SvgPicture.memory(widget.svgBytes),
                ),
              ],
            )));
  }

  PaginatedDataTable _buildPaginatedDataTable(_HSLColorDataTableSource dataSource, int dataTableRowsPerPage) {
    final dataTable = PaginatedDataTable(
      columns: const [
        DataColumn(
          label: Text('H'),
        ),
        DataColumn(
          label: Text('S'),
        ),
        DataColumn(
          label: Text('L'),
        ),
        DataColumn(
          label: Text('A'),
        ),
      ],
      source: dataSource,
      rowsPerPage: dataTableRowsPerPage,
    );
    return dataTable;
  }
}
