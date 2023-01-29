import 'dart:convert';
import 'dart:typed_data';

import 'package:ccosvg/models/svg_document.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SvgDocument.getColors() should return detected colors', () {
    const svgString = r"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg>
<style type="text/css">
  .st0{fill:#A5AE19;}
  .st1{fill:#E9E5BC;}
</style>
<g style="stroke:#000000"/>
</svg>
""";
    final svgBytes = Uint8List.fromList(utf8.encode(svgString));
    final svgDocument = SvgDocument(svgBytes);
    final colors = svgDocument.getColors();
    if (colors.length == 3) {
      expect(colors[0].elementIndex, 1);
      expect(colors[0].attributeName, null);
      expect(colors[0].startOffsetInText, 13);
      expect(colors[0].endOffsetInText, 20);
      expect(colors[0].hslColor, HSLColor.fromColor(const Color(0xffa5ae19)));
      expect(colors[1].elementIndex, 1);
      expect(colors[1].attributeName, null);
      expect(colors[1].startOffsetInText, 35);
      expect(colors[1].endOffsetInText, 42);
      expect(colors[1].hslColor, HSLColor.fromColor(const Color(0xffe9e5bc)));
      expect(colors[2].elementIndex, 2);
      expect(colors[2].attributeName, "style");
      expect(colors[2].startOffsetInText, 7);
      expect(colors[2].endOffsetInText, 14);
      expect(colors[2].hslColor, HSLColor.fromColor(const Color(0xff000000)));
    } else {
      fail("colors.length should be 3");
    }
  });
  test('SvgDocument.setColors() should set passed colors', () {
    const svgString = r"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg>
<style type="text/css">
  .st0{fill:#A5AE19;}
  .st1{fill:#E9E5BC;}
</style>
<g style="stroke:#000000"/>
</svg>
""";
    final svgBytes = Uint8List.fromList(utf8.encode(svgString));
    final svgDocument = SvgDocument(svgBytes);
    svgDocument.setColors([
      SvgColor(1, null, 13, 20, HSLColor.fromColor(const Color(0xffff0000))),
      SvgColor(1, null, 35, 42, HSLColor.fromColor(const Color(0xff00ff00))),
      SvgColor(2, "style", 7, 14, HSLColor.fromColor(const Color(0xffffffff))),
    ]);
    final actual = utf8.decode(svgDocument.bytes);
    const expected = """
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg>
<style type="text/css">
  .st0{fill:#ff0000;}
  .st1{fill:#00ff00;}
</style>
<g style="stroke:#ffffff"/>
</svg>
""";
    expect(actual, equals(expected));
  });
}
