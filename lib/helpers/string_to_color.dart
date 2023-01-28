import 'dart:ui';

Color? stringToColor(String string) {
  if (string.length == 7 && string[0] == '#') {
    return stringToColor(string.substring(1));
  }
  if (string.length == 6) {
    final rgb = int.tryParse(string, radix: 16);
    if (rgb != null) {
      final argb = 0xff000000 + rgb;
      return Color(argb);
    }
  }
  return null;
}
