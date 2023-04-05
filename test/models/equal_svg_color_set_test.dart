import 'package:ccosvg/models/equal_svg_color_set.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('EqualSvgColorSet should be initialized with member values', () {
    var svgColor = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var instance = EqualSvgColorSet(svgColor.hslColor, [svgColor]);
    expect(instance.representingValue, svgColor.hslColor);
    expect(instance.colors, [svgColor]);
  });
  test('EqualSvgColorSet should be clonable', () {
    var svgColor = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var original = EqualSvgColorSet(svgColor.hslColor, [svgColor]);
    var clone = original.clone();
    expect(clone, original);
  });
  test('SvgColor should be comparable with == and !=', () {
    var svgColor1 = SvgColor(0, "foo", 1, 2, const HSLColor.fromAHSL(1.0, 120, 0.8, 0.6));
    var svgColor2 = SvgColor(1, "foo", 1, 2, const HSLColor.fromAHSL(0.5, 120, 0.8, 0.6));
    var instance1 = EqualSvgColorSet(svgColor1.hslColor, [svgColor1, svgColor2]);
    var instance2 = EqualSvgColorSet(svgColor1.hslColor, [svgColor1, svgColor2]);
    var instance3 = EqualSvgColorSet(svgColor2.hslColor, [svgColor1, svgColor2]);
    var instance4 = EqualSvgColorSet(svgColor1.hslColor, [svgColor1]);
    expect(instance1 == instance2, true);
    expect(instance1 != instance3, true);
    expect(instance1 != instance4, true);
  });
  test('EqualSvgColorSet should be comparable', () {
    // TODO: 少々の差は同値と見なすように
    final instance1 = EqualSvgColorSet(const HSLColor.fromAHSL(0.9, 100, 0.8, 0.6), []);
    final instance2 = EqualSvgColorSet(const HSLColor.fromAHSL(0.9, 120, 0.9, 0.6), []);
    final instance3 = EqualSvgColorSet(const HSLColor.fromAHSL(0.9, 120, 0.9, 0.7), []);
    final instance4 = EqualSvgColorSet(const HSLColor.fromAHSL(1.0, 120, 0.9, 0.7), []);
    expect(instance1.compareKeyTo(instance1), 0);
    expect(instance1.compareKeyTo(instance2), -1);
    expect(instance2.compareKeyTo(instance1), 1);
    expect(instance2.compareKeyTo(instance3), -1);
    expect(instance3.compareKeyTo(instance2), 1);
    expect(instance3.compareKeyTo(instance4), -1);
    expect(instance4.compareKeyTo(instance3), 1);
  });
  test('summarizeSvgColors() should return a list of EqualSvgColorSet containing colors that are equal in tolerance',
      () {
    var svgColors = [
      SvgColor(0, "", 0, 0, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6)),
      SvgColor(2, "", 0, 0, const HSLColor.fromAHSL(1.0, 358, 0.8, 0.6)),
      SvgColor(3, "", 0, 0, const HSLColor.fromAHSL(1.0, 2, 0.805, 0.6)),
      SvgColor(4, "", 0, 0, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.599)),
      SvgColor(6, "", 0, 0, const HSLColor.fromAHSL(1.0, 12, 0.8, 0.6)),
      SvgColor(7, "", 0, 0, const HSLColor.fromAHSL(1.0, 2, 0.9, 0.6)),
      SvgColor(8, "", 0, 0, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.5)),
      SvgColor(9, "", 0, 0, const HSLColor.fromAHSL(1.0, 100, 0.4, 0.01)),
      SvgColor(10, "", 0, 0, const HSLColor.fromAHSL(1.0, 200, 0.8, 0.01)),
      SvgColor(9, "", 0, 0, const HSLColor.fromAHSL(1.0, 100, 0.01, 1)),
      SvgColor(10, "", 0, 0, const HSLColor.fromAHSL(1.0, 200, 0.01, 1)),
    ];
    var svgColorSets = summarizeSvgColors(svgColors);
    if (svgColorSets.length != 6) fail("svgColorSets.length == 6");
    expect(svgColorSets[0].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
    if (svgColorSets[0].colors.length != 4) fail("svgColorSets[0].colors.length == 4");
    expect(svgColorSets[0].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
    expect(svgColorSets[0].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 358, 0.8, 0.6));
    expect(svgColorSets[0].colors[2].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.805, 0.6));
    expect(svgColorSets[0].colors[3].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.599));
    expect(svgColorSets[1].representingValue, const HSLColor.fromAHSL(1.0, 12, 0.8, 0.6));
    if (svgColorSets[1].colors.length != 1) fail("svgColorSets[1].colors.length == 1");
    expect(svgColorSets[1].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 12, 0.8, 0.6));
    expect(svgColorSets[2].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.9, 0.6));
    if (svgColorSets[2].colors.length != 1) fail("svgColorSets[2].colors.length == 1");
    expect(svgColorSets[2].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.9, 0.6));
    expect(svgColorSets[3].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.5));
    if (svgColorSets[3].colors.length != 1) fail("svgColorSets[3].colors.length == 1");
    expect(svgColorSets[3].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.5));
    expect(svgColorSets[0].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
    if (svgColorSets[4].colors.length != 2) fail("svgColorSets[4].colors.length == 2");
    expect(svgColorSets[4].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 100, 0.4, 0.01));
    expect(svgColorSets[4].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 200, 0.8, 0.01));
    if (svgColorSets[5].colors.length != 2) fail("svgColorSets[5].colors.length == 2");
    expect(svgColorSets[5].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 100, 0.01, 1));
    expect(svgColorSets[5].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 200, 0.01, 1));
  });
}
