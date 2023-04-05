import 'package:flutter/widgets.dart';

extension HSLColorCompareToOther on HSLColor {
  int compareHueTo(HSLColor other, [double toleranceDegree = 5]) {
    var deltaH = (hue - other.hue) % 360;
    if (deltaH > 180) {
      deltaH -= 360;
    }
    if (deltaH.abs() <= toleranceDegree) {
      return 0;
    }
    return deltaH < 0 ? -1 : 1;
  }

  int compareSaturationTo(HSLColor other, [double toleranceRatio = 0.05]) {
    final deltaS = saturation - other.saturation;
    if (deltaS.abs() <= toleranceRatio) return 0;
    return deltaS < 0 ? -1 : 1;
  }

  int compareLightnessTo(HSLColor other, [double toleranceRatio = 0.05]) {
    final deltaL = lightness - other.lightness;
    if (deltaL.abs() <= toleranceRatio) return 0;
    return deltaL < 0 ? -1 : 1;
  }

  int compareAlphaTo(HSLColor other, [double toleranceRatio = 0.05]) {
    final deltaA = alpha - other.alpha;
    if (deltaA.abs() <= toleranceRatio) return 0;
    return deltaA < 0 ? -1 : 1;
  }

  int compareTo(HSLColor other, [double toleranceDegree = 5, double toleranceRatio = 0.05]) {
    final alphaResult = compareAlphaTo(other, toleranceRatio = toleranceRatio);
    if (alphaResult != 0) return alphaResult;
    if (alpha <= toleranceRatio && other.alpha < toleranceRatio) return 0;

    final lightnessResult = compareLightnessTo(other, toleranceRatio = toleranceRatio);
    if (lightnessResult != 0) return lightnessResult;
    if (lightness <= toleranceRatio && other.lightness < toleranceRatio) return 0;

    final saturationResult = compareSaturationTo(other, toleranceRatio = toleranceRatio);
    if (saturationResult != 0) return saturationResult;
    if (saturation <= toleranceRatio && other.saturation < toleranceRatio) return 0;

    final hueResult = compareHueTo(other, toleranceDegree = toleranceDegree);
    if (hueResult != 0) return hueResult;
    return 0;
  }
}
