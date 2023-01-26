import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplaySvgArguments {
  final Uint8List svgBytes;
  DisplaySvgArguments(this.svgBytes);
}

class DisplaySvgPage extends StatefulWidget {
  const DisplaySvgPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DisplaySvgPageState();
}

class _DisplaySvgPageState extends State<DisplaySvgPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DisplaySvgArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display SVG"),
      ),
      body: SvgPicture.memory(args.svgBytes),
    );
  }
}
