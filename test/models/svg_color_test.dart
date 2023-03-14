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
}
