import 'package:ccosvg/helpers/hsl_color_compare_to_other.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class EqualSvgColorSet {
  final HSLColor representingValue;
  List<SvgColor> colors;

  EqualSvgColorSet(this.representingValue, this.colors);

  EqualSvgColorSet clone() {
    var rv = representingValue;
    return EqualSvgColorSet(
        HSLColor.fromAHSL(rv.alpha, rv.hue, rv.saturation, rv.lightness), colors.map((e) => e.clone()).toList());
  }

  @override
  bool operator ==(Object other) {
    if (other is! EqualSvgColorSet) return false;
    return representingValue == other.representingValue && listEquals(colors, other.colors);
  }

  @override
  int get hashCode => Object.hash(representingValue, colors);

  int compareKeyTo(EqualSvgColorSet other, [double toleranceDegree = 5, double toleranceRatio = 0.05]) {
    return representingValue.compareTo(
        other.representingValue, toleranceDegree = toleranceDegree, toleranceRatio = toleranceRatio);
  }
}

List<EqualSvgColorSet> summarizeSvgColors(List<SvgColor> colors,
    [double toleranceDegree = 5, double toleranceRatio = 0.05]) {
  List<EqualSvgColorSet> result = [];
  for (var color in colors) {
    var found = false;
    for (var colorSet in result) {
      final comparisonResult = color.hslColor
          .compareTo(colorSet.representingValue, toleranceDegree = toleranceDegree, toleranceRatio = toleranceRatio);
      if (comparisonResult != 0) continue;
      colorSet.colors.add(color);
      found = true;
      break;
    }
    if (!found) {
      result.add(EqualSvgColorSet(color.hslColor, [color]));
    }
  }
  return result;
}
