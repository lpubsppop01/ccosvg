import 'package:ccosvg/models/svg_color.dart';
import 'package:flutter/widgets.dart';

class EqualSvgColorSet {
  final HSLColor representingValue;
  List<SvgColor> colors;
  EqualSvgColorSet(this.representingValue, this.colors);
}

List<EqualSvgColorSet> summarizeSvgColors(List<SvgColor> colors,
    [double toleranceDegree = 5, double toleranceRatio = 0.05]) {
  List<EqualSvgColorSet> result = [];
  for (var color in colors) {
    var found = false;
    for (var colorSet in result) {
      var deltaL = color.hslColor.lightness - colorSet.representingValue.lightness;
      if (deltaL.abs() > toleranceRatio) continue;
      if (colorSet.representingValue.lightness > toleranceRatio) {
        var deltaS = color.hslColor.saturation - colorSet.representingValue.saturation;
        if (deltaS.abs() > toleranceRatio) continue;
        if (colorSet.representingValue.saturation > toleranceRatio) {
          var deltaH = (color.hslColor.hue - colorSet.representingValue.hue) % 360;
          if (deltaH > 180) {
            deltaH -= 360;
          }
          if (deltaH.abs() > toleranceDegree) continue;
        }
      }
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
