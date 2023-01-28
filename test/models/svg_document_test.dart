import 'dart:convert';
import 'dart:typed_data';

import 'package:ccosvg/models/svg_document.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SvgDocument.getColors() should return detected colors', (_) async {
    const svgString = r"""
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg>
<style type="text/css">
	.st0{fill:#A5AE19;}
	.st1{fill:#E9E5BC;}
</style>
</svg>
""";
    final svgBytes = Uint8List.fromList(utf8.encode(svgString));
    final svgDocument = SvgDocument(svgBytes);
    final colors = svgDocument.getColors();
    if (colors.length == 2) {
      expect(colors[0].hslColor, HSLColor.fromColor(const Color(0xffa5ae19)));
      expect(colors[1].hslColor, HSLColor.fromColor(const Color(0xffe9e5bc)));
    } else {
      fail("colors.length should be 2");
    }
  });
}
