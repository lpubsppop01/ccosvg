import 'dart:convert';
import 'dart:typed_data';

import 'package:ccosvg/helpers/string_to_color.dart';
import 'package:ccosvg/models/svg_color.dart';
import 'package:collection/collection.dart';
import 'package:csslib/visitor.dart';
import 'package:flutter/widgets.dart';
import 'package:xml/xml.dart';
import 'package:csslib/parser.dart' as csslib_parser;
import 'package:csslib/visitor.dart' as csslib_visitor;

class _MyVisitorToFindColors extends csslib_visitor.Visitor {
  int elementIndex;
  String? attributeName;
  int offsetDelta;
  List<SvgColor> foundColors = [];
  _MyVisitorToFindColors(this.elementIndex, this.attributeName, this.offsetDelta);

  @override
  dynamic visitHexColorTerm(csslib_visitor.HexColorTerm node) {
    super.visitHexColorTerm(node);

    final startOffsetInText = node.span?.start.offset;
    if (startOffsetInText == null) return;
    final endOffsetInText = node.span?.end.offset;
    if (endOffsetInText == null) return;
    final color = stringToColor(node.span?.text ?? "");
    if (color == null) return;
    final hslColor = HSLColor.fromColor(color);
    foundColors.add(SvgColor(
        elementIndex, attributeName, startOffsetInText + offsetDelta, endOffsetInText + offsetDelta, hslColor));
  }
}

class _MyVisitorToFindClasses extends csslib_visitor.Visitor {
  final Map<String, String> classNameToStyle = {};

  @override
  dynamic visitRuleSet(RuleSet node) {
    super.visitRuleSet(node);

    String? className;
    final selectors = node.selectorGroup?.selectors;
    if (selectors != null && selectors.length == 1) {
      final sequences = selectors[0].simpleSelectorSequences;
      if (sequences.length == 1) {
        final combinator = sequences[0].combinator;
        if (combinator == csslib_parser.TokenKind.COMBINATOR_NONE) {
          final simpleSelector = sequences[0].simpleSelector;
          className = simpleSelector.name;
        }
      }
    }
    if (className == null) return;

    final declarationGroupText = node.declarationGroup.span.text;
    final declarationsText = declarationGroupText.substring(1, declarationGroupText.length - 1);
    classNameToStyle[className] = declarationsText;
  }
}

class SvgDocument {
  Uint8List bytes;
  SvgDocument(this.bytes);

  List<SvgColor> getColors() {
    final string = utf8.decode(bytes);
    final xmlDocument = XmlDocument.parse(string);
    List<SvgColor> colors = [];
    int index = 0;
    for (var element in xmlDocument.descendantElements) {
      if (element.name.local == "style" &&
          element.attributes.any((a) => a.name.local == "type" && a.value == "text/css")) {
        final styleSheet = csslib_parser.parse(element.text);
        final visitor = _MyVisitorToFindColors(index, null, 0);
        styleSheet.visit(visitor);
        colors.addAll(visitor.foundColors);
      } else {
        final attribute = element.attributes.firstWhereOrNull((a) => a.name.local == "style");
        if (attribute != null) {
          final styleSheet = csslib_parser.parse(".st0{" + attribute.value + ";}");
          final visitor = _MyVisitorToFindColors(index, "style", -".st0{".length);
          styleSheet.visit(visitor);
          colors.addAll(visitor.foundColors);
        }
      }
      ++index;
    }
    return colors;
  }

  setColors(List<SvgColor> colors) {
    final string = utf8.decode(bytes);
    final xmlDocument = XmlDocument.parse(string);
    int index = 0;
    for (var element in xmlDocument.descendantElements) {
      var currColors = colors.where((color) => color.elementIndex == index).toList();
      currColors.sort((lhs, rhs) => lhs.startOffsetInText.compareTo(rhs.startOffsetInText));
      int offsetDelta = 0;
      for (var currColor in currColors) {
        final rgb = currColor.hslColor.toColor();
        final r = rgb.red.toRadixString(16).padLeft(2, "0");
        final g = rgb.green.toRadixString(16).padLeft(2, "0");
        final b = rgb.blue.toRadixString(16).padLeft(2, "0");
        final currColorString = "#" + r + g + b;
        offsetDelta += currColorString.length - (currColor.endOffsetInText - currColor.startOffsetInText);
        final attributeName = currColor.attributeName;
        if (attributeName != null) {
          final attribute = element.attributes.firstWhereOrNull((a) => a.name.local == attributeName);
          if (attribute != null) {
            final newValue = attribute.value.replaceRange(
                currColor.startOffsetInText + offsetDelta, currColor.endOffsetInText + offsetDelta, currColorString);
            attribute.value = newValue;
          }
        } else {
          final newInnerText = element.innerText.replaceRange(
              currColor.startOffsetInText + offsetDelta, currColor.endOffsetInText + offsetDelta, currColorString);
          element.innerText = newInnerText;
        }
      }
      ++index;
    }
    bytes = Uint8List.fromList(utf8.encode(xmlDocument.toXmlString()));
  }

  SvgDocument simplified() {
    final string = utf8.decode(bytes);
    final xmlDocument = XmlDocument.parse(string);
    final Map<String, String> classNameToStyle = {};
    for (var element in xmlDocument.descendantElements) {
      if (element.name.local == "style" &&
          element.attributes.any((a) => a.name.local == "type" && a.value == "text/css")) {
        final styleSheet = csslib_parser.parse(element.text);
        final visitor = _MyVisitorToFindClasses();
        styleSheet.visit(visitor);
        classNameToStyle.addAll(visitor.classNameToStyle);
      } else {
        final classAttribute = element.attributes.firstWhereOrNull((a) => a.name.local == 'class');
        if (classAttribute != null) {
          final className = classAttribute.value;
          final styleAttribute = element.attributes.firstWhereOrNull((a) => a.name.local == 'style');
          if (styleAttribute == null) {
            final classStyle = classNameToStyle[className];
            if (classStyle != null) {
              element.setAttribute('style', classStyle);
            }
          }
        }
      }
    }

    final simplifiedBytes = Uint8List.fromList(utf8.encode(xmlDocument.toXmlString()));
    return SvgDocument(simplifiedBytes);
  }
}
