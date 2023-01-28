import 'dart:convert';
import 'dart:typed_data';

import 'package:ccosvg/helpers/string_to_color.dart';
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
import 'package:csslib/parser.dart' as csslib_parser;
import 'package:csslib/visitor.dart' as csslib_visitor;

class SvgColor {
  final int sourceStartOffset;
  final int sourceEndOffset;
  final HSLColor hslColor;
  SvgColor(this.sourceStartOffset, this.sourceEndOffset, this.hslColor);
}

class _MyVisitor extends csslib_visitor.Visitor {
  List<SvgColor> foundColors = [];
  @override
  dynamic visitHexColorTerm(csslib_visitor.HexColorTerm node) {
    final sourceStartOffset = node.span?.start.offset;
    if (sourceStartOffset == null) return;
    final sourceEndOffset = node.span?.end.offset;
    if (sourceEndOffset == null) return;
    final color = stringToColor(node.text);
    if (color == null) return;
    final hslColor = HSLColor.fromColor(color);
    foundColors.add(SvgColor(sourceStartOffset, sourceEndOffset, hslColor));
  }
}

class SvgDocument {
  Uint8List bytes;
  SvgDocument(this.bytes);

  List<SvgColor> getColors() {
    final string = utf8.decode(bytes);
    final xmlDocument = XmlDocument.parse(string);
    List<SvgColor> colors = [];
    for (var element in xmlDocument.descendantElements) {
      if (element.name.local == "style" &&
          element.attributes.any((a) => a.name.local == "type" && a.value == "text/css")) {
        final styleSheet = csslib_parser.parse(element.text);
        final visitor = _MyVisitor();
        styleSheet.visit(visitor);
        colors.addAll(visitor.foundColors);
      }
    }
    return colors;
  }
}
