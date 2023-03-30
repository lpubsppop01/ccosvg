import 'package:flutter/material.dart';

class CheckerboardPanel extends StatelessWidget {
  final double cellSize;
  final Color oddColor;
  final Color evenColor;
  final globalKey = GlobalKey();
  CheckerboardPanel(this.cellSize, this.oddColor, this.evenColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cellCountX = (screenSize.width / cellSize).ceil() + 1;
    final cellCountY = (screenSize.height / cellSize).ceil() + 1;

    List<Column> columns = [];
    for (var x = 0; x < cellCountX; ++x) {
      final cellWidth = (x < cellCountX - 1) ? cellSize : screenSize.width % cellSize;
      List<Container> cellsInColumn = [];
      for (var y = 0; y < cellCountY; ++y) {
        final cellHeight = (y < cellCountY - 1) ? cellSize : screenSize.height % cellSize;
        cellsInColumn.add(Container(
          color: (x % 2 == y % 2) ? evenColor : oddColor,
          width: cellWidth,
          height: cellHeight,
        ));
      }
      columns.add(Column(children: cellsInColumn));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(children: columns),
      ),
    );
  }
}
