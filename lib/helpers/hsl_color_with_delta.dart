import 'dart:math';

import 'package:flutter/cupertino.dart';

extension HSLColorWithDelta on HSLColor {
  HSLColor withHueDelta(num delta) {
    final newValue = (hue + delta) % 360;
    return withHue(newValue);
  }

  HSLColor withSaturationDelta(double delta) {
    final newValue = min(1.0, max(0.0, saturation + delta));
    return withSaturation(newValue);
  }

  HSLColor withLightnessDelta(double delta) {
    final newValue = min(1.0, max(0.0, lightness + delta));
    return withLightness(newValue);
  }

  HSLColor withAlphaDelta(double delta) {
    final newValue = min(1.0, max(0.0, alpha + delta));
    return withAlpha(newValue);
  }
}
