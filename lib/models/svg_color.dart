import 'package:flutter/widgets.dart';

class SvgColor {
  final int elementIndex;
  final String? attributeName;
  final int startOffsetInText;
  final int endOffsetInText;
  HSLColor hslColor;

  SvgColor(this.elementIndex, this.attributeName, this.startOffsetInText, this.endOffsetInText, this.hslColor);

  SvgColor clone() {
    return SvgColor(elementIndex, attributeName, startOffsetInText, endOffsetInText, hslColor);
  }

  @override
  bool operator ==(Object other) {
    if (other is! SvgColor) return false;
    return elementIndex == other.elementIndex &&
        attributeName == other.attributeName &&
        startOffsetInText == other.startOffsetInText &&
        endOffsetInText == other.endOffsetInText &&
        hslColor == other.hslColor;
  }

  @override
  int get hashCode => Object.hash(elementIndex, attributeName, startOffsetInText, endOffsetInText, hslColor);
}
