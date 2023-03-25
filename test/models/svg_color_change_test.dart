import 'package:ccosvg/models/svg_color.dart';
import 'package:ccosvg/models/svg_color_change.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SvgColorChange() should work', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.hue,
      SvgColorChangeDeltaKind.value,
      10,
    );
    expect(instance.targetComponent, SvgColorChangeTargetComponent.hue);
    expect(instance.kind, SvgColorChangeDeltaKind.value);
    expect(instance.delta, 10);
  });
  test('SvgColorChange.applyToColor() should work with "hue" and "value"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.hue,
      SvgColorChangeDeltaKind.value,
      10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 10, 1, 1));
    expect(actual, expected);
  });
  test('SvgColorChange.applyToColor() should work with "hue" and "percentageInLimit"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.hue,
      SvgColorChangeDeltaKind.percentageInLimit,
      10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 360 * 0.1, 1, 1));
    expect(actual, expected);
  });
  test('SvgColorChange.applyToColor() should work with "saturation" and "value"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.saturation,
      SvgColorChangeDeltaKind.value,
      -10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 0.9, 1));
    expect(actual, expected);
  });
  test('SvgColorChange.applyToColor() should work with "saturation" and "percentageInLimit"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.saturation,
      SvgColorChangeDeltaKind.percentageInLimit,
      -10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 0.9, 1));
    expect(actual, expected);
  });
  test('SvgColorChange.applyToColor() should work with "lightness" and "value"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.lightness,
      SvgColorChangeDeltaKind.value,
      -10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 0.9));
    expect(actual, expected);
  });
  test('SvgColorChange.applyToColor() should work with "lightness" and "percentageInLimit"', () {
    var instance = SvgColorChange(
      SvgColorChangeTargetComponent.lightness,
      SvgColorChangeDeltaKind.percentageInLimit,
      -10,
    );
    var actual = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 1));
    instance.applyToColor(actual);
    var expected = SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1, 0, 1, 0.9));
    expect(actual, expected);
  });
}
