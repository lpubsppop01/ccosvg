import 'dart:ui';

import 'package:ccosvg/helpers/hsl_color_with_delta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('withHueDelta() should return a new value with a hue that is the sum of the original value and the delta', () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(10), const HSLColor.fromAHSL(0, 10, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(370), const HSLColor.fromAHSL(0, 10, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(-350), const HSLColor.fromAHSL(0, 10, 0, 0));
  });
  test(
      'withSaturationDelta() should return a new value with a saturation that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(0.5), const HSLColor.fromAHSL(0, 0, 0.5, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(1.5), const HSLColor.fromAHSL(0, 0, 1, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
  test(
      'withLightnessDelta() should return a new value with a lightness that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(0.5), const HSLColor.fromAHSL(0, 0, 0, 0.5));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(1.5), const HSLColor.fromAHSL(0, 0, 0, 1));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
  test('withAlphaDelta() should return a new value with a alpha that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(0.5), const HSLColor.fromAHSL(0.5, 0, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(1.5), const HSLColor.fromAHSL(1, 0, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
}
