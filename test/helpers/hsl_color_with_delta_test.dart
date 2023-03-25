import 'package:ccosvg/helpers/hsl_color_with_delta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('withHueDelta() should return a new value with a hue that is the sum of the original value and the delta', () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(10), const HSLColor.fromAHSL(0, 10, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(370), const HSLColor.fromAHSL(0, 10, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withHueDelta(-350), const HSLColor.fromAHSL(0, 10, 0, 0));
  });
  test('withHueDeltaPercentageInChangeableRange() should work.', () {
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0).withHueDeltaPercentageInChangeableRange(0.1),
      const HSLColor.fromAHSL(0, 360 * 0.1, 0, 0),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0).withHueDeltaPercentageInChangeableRange(1.1),
      const HSLColor.fromAHSL(0, 360 * 1.1 - 360, 0, 0),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0).withHueDeltaPercentageInChangeableRange(-0.1),
      const HSLColor.fromAHSL(0, 360 - 360 * 0.1, 0, 0),
    );
  });
  test(
      'withSaturationDelta() should return a new value with a saturation that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(0.5), const HSLColor.fromAHSL(0, 0, 0.5, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(1.5), const HSLColor.fromAHSL(0, 0, 1, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withSaturationDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
  test('withSaturationDeltaPercentageInChangeableRange() should work.', () {
    expect(
      const HSLColor.fromAHSL(0, 0, 0.5, 0).withSaturationDeltaPercentageInChangeableRange(0.1),
      const HSLColor.fromAHSL(0, 0, 0.55, 0),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0.5, 0).withSaturationDeltaPercentageInChangeableRange(1.1),
      const HSLColor.fromAHSL(0, 0, 1, 0),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0.5, 0).withSaturationDeltaPercentageInChangeableRange(-0.1),
      const HSLColor.fromAHSL(0, 0, 0.45, 0),
    );
  });
  test(
      'withLightnessDelta() should return a new value with a lightness that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(0.5), const HSLColor.fromAHSL(0, 0, 0, 0.5));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(1.5), const HSLColor.fromAHSL(0, 0, 0, 1));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withLightnessDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
  test('withLightnessDeltaPercentageInChangeableRange() should work.', () {
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0.5).withLightnessDeltaPercentageInChangeableRange(0.1),
      const HSLColor.fromAHSL(0, 0, 0, 0.55),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0.5).withLightnessDeltaPercentageInChangeableRange(1.1),
      const HSLColor.fromAHSL(0, 0, 0, 1),
    );
    expect(
      const HSLColor.fromAHSL(0, 0, 0, 0.5).withLightnessDeltaPercentageInChangeableRange(-0.1),
      const HSLColor.fromAHSL(0, 0, 0, 0.45),
    );
  });
  test('withAlphaDelta() should return a new value with a alpha that is the sum of the original value and the delta',
      () {
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(0.5), const HSLColor.fromAHSL(0.5, 0, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(1.5), const HSLColor.fromAHSL(1, 0, 0, 0));
    expect(const HSLColor.fromAHSL(0, 0, 0, 0).withAlphaDelta(-0.5), const HSLColor.fromAHSL(0, 0, 0, 0));
  });
  test('withAlphaDeltaPercentageInChangeableRange() should work.', () {
    expect(
      const HSLColor.fromAHSL(0.5, 0, 0, 0).withAlphaDeltaPercentageInChangeableRange(0.1),
      const HSLColor.fromAHSL(0.55, 0, 0, 0),
    );
    expect(
      const HSLColor.fromAHSL(0.5, 0, 0, 0).withAlphaDeltaPercentageInChangeableRange(1.1),
      const HSLColor.fromAHSL(1, 0, 0, 0),
    );
    expect(
      const HSLColor.fromAHSL(0.5, 0, 0, 0).withAlphaDeltaPercentageInChangeableRange(-0.1),
      const HSLColor.fromAHSL(0.45, 0, 0, 0),
    );
  });
}
