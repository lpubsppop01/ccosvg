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
    if (svgColorSets.length == 6) {
      expect(svgColorSets[0].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
      if (svgColorSets[0].colors.length == 4) {
        expect(svgColorSets[0].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
        expect(svgColorSets[0].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 358, 0.8, 0.6));
        expect(svgColorSets[0].colors[2].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.805, 0.6));
        expect(svgColorSets[0].colors[3].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.599));
      } else {
        fail("svgColorSets[0].colors.length == 4");
      }
      expect(svgColorSets[1].representingValue, const HSLColor.fromAHSL(1.0, 12, 0.8, 0.6));
      if (svgColorSets[1].colors.length == 1) {
        expect(svgColorSets[1].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 12, 0.8, 0.6));
      } else {
        fail("svgColorSets[1].colors.length == 1");
      }
      expect(svgColorSets[2].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.9, 0.6));
      if (svgColorSets[2].colors.length == 1) {
        expect(svgColorSets[2].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.9, 0.6));
      } else {
        fail("svgColorSets[2].colors.length == 1");
      }
      expect(svgColorSets[3].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.5));
      if (svgColorSets[3].colors.length == 1) {
        expect(svgColorSets[3].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.5));
      } else {
        fail("svgColorSets[3].colors.length == 1");
      }
      expect(svgColorSets[0].representingValue, const HSLColor.fromAHSL(1.0, 2, 0.8, 0.6));
      if (svgColorSets[4].colors.length == 2) {
        expect(svgColorSets[4].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 100, 0.4, 0.01));
        expect(svgColorSets[4].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 200, 0.8, 0.01));
      } else {
        fail("svgColorSets[4].colors.length == 2");
      }
      if (svgColorSets[5].colors.length == 2) {
        expect(svgColorSets[5].colors[0].hslColor, const HSLColor.fromAHSL(1.0, 100, 0.01, 1));
        expect(svgColorSets[5].colors[1].hslColor, const HSLColor.fromAHSL(1.0, 200, 0.01, 1));
      } else {
        fail("svgColorSets[5].colors.length == 2");
      }
    } else {
      fail("svgColorSets.length == 4");
    }
  });
}
