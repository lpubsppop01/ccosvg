import 'dart:math';

import 'package:flutter/cupertino.dart';

extension HSLColorWithDelta on HSLColor {
  HSLColor withHueDelta(num delta) {
    final newValue = (hue + delta) % 360;
    return withHue(newValue);
  }

  HSLColor withHueDeltaPercentageInChangeableRange(num percentage) {
    return withHueDelta(360 * percentage);
  }

  HSLColor withSaturationDelta(double delta) {
    final newValue = min(1.0, max(0.0, saturation + delta));
    return withSaturation(newValue);
  }

  HSLColor withSaturationDeltaPercentageInChangeableRange(num percentage) {
    if (percentage > 0) {
      return withSaturationDelta(max(0.0, 1.0 - saturation) * percentage);
    } else {
      return withSaturationDelta(max(0.0, saturation) * percentage);
    }
  }

  HSLColor withLightnessDelta(double delta) {
    final newValue = min(1.0, max(0.0, lightness + delta));
    return withLightness(newValue);
  }

  HSLColor withLightnessDeltaPercentageInChangeableRange(num percentage) {
    if (percentage > 0) {
      return withLightnessDelta(max(0.0, 1.0 - lightness) * percentage);
    } else {
      return withLightnessDelta(max(0.0, lightness) * percentage);
    }
  }

  HSLColor withAlphaDelta(double delta) {
    final newValue = min(1.0, max(0.0, alpha + delta));
    return withAlpha(newValue);
  }

  HSLColor withAlphaDeltaPercentageInChangeableRange(num percentage) {
    if (percentage > 0) {
      return withAlphaDelta(max(0.0, 1.0 - alpha) * percentage);
    } else {
      return withAlphaDelta(max(0.0, alpha) * percentage);
    }
  }

}
