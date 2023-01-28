import 'dart:ui';

import 'package:ccosvg/helpers/string_to_color.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stringToColor() should parse 6-digit hexadecimal notation starts with #', (_) async {
    final actual = stringToColor("#112233");
    if (actual == null) {
      fail("actual should not be null");
    }
    expect(actual, equals(const Color.fromARGB(0xff, 0x11, 0x22, 0x33)));
  });
  testWidgets('stringToColor() should parse 6-digit hexadecimal notation', (_) async {
    final actual = stringToColor("112233");
    if (actual == null) {
      fail("actual should not be null");
    }
    expect(actual, equals(const Color.fromARGB(0xff, 0x11, 0x22, 0x33)));
  });
}
