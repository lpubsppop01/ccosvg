import 'package:ccosvg/constants.dart';
import 'package:ccosvg/helpers/show_message.dart';
import 'package:ccosvg/models/equal_svg_color_set.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:ccosvg/models/svg_color_change.dart';
import 'package:ccosvg/models/svg_document.dart';
import 'package:ccosvg/widgets/change_color_panel.dart';
import 'package:ccosvg/widgets/checkerboard_panel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class DisplaySvgPage extends StatefulWidget {
  const DisplaySvgPage({Key? key}) : super(key: key);
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
  String? editingLabel;
  Uint8List? backupSvgBytes;
  List<SvgColor>? backupSvgColors;
  List<EqualSvgColorSet>? backupSvgColorSets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CCoSVG"),
        actions: [
          IconButton(onPressed: _infoButtonPressed, icon: const Icon(Icons.info)),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (svgBytes.isEmpty) {
      return _buildInitialBody();
    } else {
      final double deviceWidth = MediaQuery.of(context).size.width;
      final double deviceHeight = MediaQuery.of(context).size.height;
      return deviceWidth < deviceHeight
          ? _buildPortraitBody(context, deviceWidth, deviceHeight)
          : _buildLandscapeBody(context, deviceWidth, deviceHeight);
    }
  }

  Widget _buildInitialBody() {
    return Stack(children: [
      CheckerboardPanel(25, Colors.black12, Colors.black38),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _openSvgFileButtonPressed,
                child: const Text(
                  'Open SVG File',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildPortraitBody(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
    final dataTableHeightMax = deviceHeight * 0.5 - 56 - 56 - 56 - 8;
    final dataTableRowsPerPage = (dataTableHeightMax / kMinInteractiveDimension).truncate();
    final dataTableHeight = dataTableRowsPerPage * kMinInteractiveDimension + 56 + 56 + 8;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: dataTableHeight,
                  child: _buildPaginatedDataTable(context, dataSource, dataTableRowsPerPage)),
              SizedBox(width: double.infinity, height: dataTableHeight, child: _buildChangeColorPanel(context)),
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            height: 1,
          ),
          Expanded(
            child: Stack(children: [
              CheckerboardPanel(25, Colors.black12, Colors.black38),
              SvgPicture.memory(SvgDocument(svgBytes).simplified().bytes),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _downloadButtonPressed,
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    onPressed: _closeButtonPressed,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeBody(BuildContext context, double deviceWidth, double deviceHeight) {
    final dataSource = _HSLColorDataTableSource(svgColorSets, selectedIndices, _onSelectionChanged);
    final dataTableHeightMax = deviceHeight - 56 - 56 - 56 - 8;
    final dataTableRowsPerPage = (dataTableHeightMax / kMinInteractiveDimension).truncate();
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
                  child: _buildPaginatedDataTable(context, dataSource, dataTableRowsPerPage)),
              SizedBox(width: deviceWidth * 0.5, height: double.infinity, child: _buildChangeColorPanel(context)),
            ]),
          ),
          VerticalDivider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: Stack(children: [
              CheckerboardPanel(25, Colors.black12, Colors.black38),
              SvgPicture.memory(SvgDocument(svgBytes).simplified().bytes),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _downloadButtonPressed,
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    onPressed: _closeButtonPressed,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ]),
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

  Widget _buildPaginatedDataTable(BuildContext context, _HSLColorDataTableSource dataSource, int dataTableRowsPerPage) {
    return Visibility(
        child: PaginatedDataTable(
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
        ),
        visible: editingLabel == null);
  }

  DataColumn _buildDataColumn(BuildContext context, String label) {
    final editButtonOrSpace = Visibility(
        child: IconButton(
            iconSize: 18,
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
        visible: editingLabel != null);
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

  void _openSvgFileButtonPressed() async {
    var result = await FilePicker.platform.pickFiles();
    if (result == null) {
      await showMessage(context, "Error", "FilePicker.platform.pickFiles() returned null. Please retry.");
      return;
    }
    var svgBytes = result.files.first.bytes;
    if (svgBytes == null) {
      await showMessage(context, "Error", "result.files.first.bytes is null. Please retry.");
      return;
    }
    setState(() {
      this.svgBytes = svgBytes;
      svgColors = SvgDocument(svgBytes).getColors();
      svgColorSets = summarizeSvgColors(svgColors, 36, 0.1);
      firstVisibleRowIndex = svgColors.isEmpty ? null : 0;
      editingLabel = null;
      backupSvgBytes = null;
      backupSvgColors = null;
      backupSvgColorSets = null;
    });
  }

  void _infoButtonPressed() async {
    final info = await PackageInfo.fromPlatform();
    showAboutDialog(
        context: context,
        applicationName: 'CCoSVG',
        applicationVersion: '${info.version} (${info.buildNumber})',
        applicationIcon: null,
        applicationLegalese: "©2023- lpubsppop01",
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "lpubsppop01/ccosvg",
                    style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = Uri.parse('https://github.com/lpubsppop01/ccosvg');
                        if (kIsWeb) {
                          // Use the plugin object directly because it didn't work as a plugin in the deployed site
                          var plugin = UrlLauncherPlugin();
                          if (await plugin.canLaunch(url.toString())) {
                            await plugin.launch(url.toString());
                          }
                        } else if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }),
              ])))
        ]);
  }

  void _closeButtonPressed() {
    setState(() {
      svgBytes = Uint8List(0);
      svgColors = [];
      svgColorSets = [];
      firstVisibleRowIndex = null;
      editingLabel = null;
      backupSvgBytes = null;
      backupSvgColors = null;
      backupSvgColorSets = null;
    });
  }

  void _downloadButtonPressed() {
    FileSaver.instance.saveFile("ccosvg_result.svg", svgBytes, "");
  }
}
