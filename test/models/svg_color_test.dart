import 'package:ccosvg/models/svg_color.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SvgColor should be initialized with member values', () {
    var hslColor = const HSLColor.fromAHSL(1, 120, 0.8, 0.6);
    var instance = SvgColor(0, "foo", 1, 2, hslColor);
    expect(instance.elementIndex, 0);
    expect(instance.attributeName, "foo");
    expect(instance.startOffsetInText, 1);
    expect(instance.endOffsetInText, 2);
    expect(instance.hslColor, hslColor);
  });
  test('SvgColor should be clonable', () {
    var original = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var clone = original.clone();
    expect(clone, original);
  });
  test('SvgColor should be comparable with == and !=', () {
    var instance1 = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance2 = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance3 = SvgColor(1, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance4 = SvgColor(0, "bar", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance5 = SvgColor(0, "foo", 2, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance6 = SvgColor(0, "foo", 1, 3, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance7 = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(0.5, 120, 0.8, 0.6));
    expect(instance1 == instance2, true);
    expect(instance1 != instance3, true);
    expect(instance1 != instance4, true);
    expect(instance1 != instance5, true);
    expect(instance1 != instance6, true);
    expect(instance1 != instance7, true);
  });
}
