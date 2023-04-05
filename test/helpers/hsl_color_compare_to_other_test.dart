import 'package:ccosvg/helpers/hsl_color_compare_to_other.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HSLColor.compareHueTo() should return -1, 0, or 1 as a comparison result', () {
    const value = HSLColor.fromAHSL(1, 0, 0.5, 0.5);
    const valueEq1 = HSLColor.fromAHSL(1, 5, 0.5, 0.5);
    const valueEq2 = HSLColor.fromAHSL(1, 355, 0.5, 0.5);
    const valueGt = HSLColor.fromAHSL(1, 10, 0.5, 0.5);
    const valueLt = HSLColor.fromAHSL(1, 350, 0.5, 0.5);
    expect(value.compareHueTo(value), 0);
    expect(value.compareHueTo(valueEq1), 0);
    expect(value.compareHueTo(valueEq2), 0);
    expect(value.compareHueTo(valueGt), -1);
    expect(value.compareHueTo(valueLt), 1);
  });
  test('HSLColor.compareSaturationTo() should return -1, 0, or 1 as a comparison result', () {
    const value = HSLColor.fromAHSL(1, 0, 0.5, 0.5);
    const valueEq1 = HSLColor.fromAHSL(1, 0, 0.54, 0.5);
    const valueEq2 = HSLColor.fromAHSL(1, 0, 0.46, 0.5);
    const valueGt = HSLColor.fromAHSL(1, 0, 0.6, 0.5);
    const valueLt = HSLColor.fromAHSL(1, 0, 0.4, 0.5);
    expect(value.compareSaturationTo(value), 0);
    expect(value.compareSaturationTo(valueEq1), 0);
    expect(value.compareSaturationTo(valueEq2), 0);
    expect(value.compareSaturationTo(valueGt), -1);
    expect(value.compareSaturationTo(valueLt), 1);
  });
  test('HSLColor.compareLightnessTo() should return -1, 0, or 1 as a comparison result', () {
    const value = HSLColor.fromAHSL(1, 0, 0.5, 0.5);
    const valueEq1 = HSLColor.fromAHSL(1, 0, 0.5, 0.54);
    const valueEq2 = HSLColor.fromAHSL(1, 0, 0.5, 0.46);
    const valueGt = HSLColor.fromAHSL(1, 0, 0.5, 0.6);
    const valueLt = HSLColor.fromAHSL(1, 0, 0.5, 0.4);
    expect(value.compareLightnessTo(value), 0);
    expect(value.compareLightnessTo(valueEq1), 0);
    expect(value.compareLightnessTo(valueEq2), 0);
    expect(value.compareLightnessTo(valueGt), -1);
    expect(value.compareLightnessTo(valueLt), 1);
  });
  test('HSLColor.compareAlphaTo() should return -1, 0, or 1 as a comparison result', () {
    const value = HSLColor.fromAHSL(0.5, 0, 0.5, 0.5);
    const valueEq1 = HSLColor.fromAHSL(0.54, 0, 0.5, 0.5);
    const valueEq2 = HSLColor.fromAHSL(0.46, 0, 0.5, 0.5);
    const valueGt = HSLColor.fromAHSL(0.6, 0, 0.5, 0.5);
    const valueLt = HSLColor.fromAHSL(0.4, 0, 0.5, 0.5);
    expect(value.compareAlphaTo(value), 0);
    expect(value.compareAlphaTo(valueEq1), 0);
    expect(value.compareAlphaTo(valueEq2), 0);
    expect(value.compareAlphaTo(valueGt), -1);
    expect(value.compareAlphaTo(valueLt), 1);
  });
  test('HSLColor.compareTo() should return -1, 0, or 1 as a comparison result', () {
    const value = HSLColor.fromAHSL(0.5, 0, 0.5, 0.5);
    const valueEq1 = HSLColor.fromAHSL(0.54, 5, 0.54, 0.54);
    const valueEq2 = HSLColor.fromAHSL(0.46, 355, 0.46, 0.46);
    const valueGt1 = HSLColor.fromAHSL(0.5, 10, 0.5, 0.5);
    const valueGt2 = HSLColor.fromAHSL(0.5, 0, 0.6, 0.5);
    const valueGt3 = HSLColor.fromAHSL(0.5, 0, 0.5, 0.6);
    const valueGt4 = HSLColor.fromAHSL(0.6, 0, 0.5, 0.5);
    const valueLt1 = HSLColor.fromAHSL(0.5, 350, 0.5, 0.5);
    const valueLt2 = HSLColor.fromAHSL(0.5, 0, 0.4, 0.5);
    const valueLt3 = HSLColor.fromAHSL(0.5, 0, 0.5, 0.4);
    const valueLt4 = HSLColor.fromAHSL(0.4, 0, 0.5, 0.5);
    const valueW1 = HSLColor.fromAHSL(0.5, 0, 0, 1);
    const valueW2 = HSLColor.fromAHSL(0.5, 10, 0, 1);
    const valueBk1 = HSLColor.fromAHSL(0.5, 0, 0.5, 0);
    const valueBk2 = HSLColor.fromAHSL(0.5, 10, 0.5, 0);
    const valueBk3 = HSLColor.fromAHSL(0.5, 0, 1, 0);
    expect(value.compareTo(value), 0);
    expect(value.compareTo(valueEq1), 0);
    expect(value.compareTo(valueEq2), 0);
    expect(value.compareTo(valueGt1), -1);
    expect(value.compareTo(valueGt2), -1);
    expect(value.compareTo(valueGt3), -1);
    expect(value.compareTo(valueGt4), -1);
    expect(value.compareTo(valueLt1), 1);
    expect(value.compareTo(valueLt2), 1);
    expect(value.compareTo(valueLt3), 1);
    expect(value.compareTo(valueLt4), 1);
    expect(valueW1.compareTo(valueW2), 0);
    expect(valueBk1.compareTo(valueBk2), 0);
    expect(valueBk1.compareTo(valueBk3), 0);
  });
}
