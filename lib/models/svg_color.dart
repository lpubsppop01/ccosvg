import 'package:flutter/widgets.dart';

class SvgColor {
  final int elementIndex;
  final String? attributeName;
  final int startOffsetInText;
  final int endOffsetInText;
  HSLColor hslColor;
  SvgColor(this.elementIndex, this.attributeName, this.startOffsetInText, this.endOffsetInText, this.hslColor);
}
