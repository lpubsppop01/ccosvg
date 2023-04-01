import 'package:ccosvg/helpers/show_message.dart';
import 'package:ccosvg/widgets/display_svg_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'checkerboard_panel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CCoSVG"),
        actions: [
          IconButton(onPressed: _infoButtonPressed, icon: const Icon(Icons.info)),
        ],
      ),
      body: Stack(children: [
        CheckerboardPanel(25, Colors.black12, Colors.black38),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: _openSvgFileButtonPressed,
                  child: const Text(
                    'Open SVG File',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void _openSvgFileButtonPressed() async {
    var result = await FilePicker.platform.pickFiles();
    if (result == null) {
      await showMessage(context, "Error", "FilePicker.platform.pickFiles() returned null. Please retry.");
      return;
    }
    var svgName = result.files.first.name;
    if (svgName.isEmpty) {
      await showMessage(context, "Error", "result.files.first.name is empty. Please retry.");
      return;
    }
    var svgBytes = result.files.first.bytes;
    if (svgBytes == null) {
      await showMessage(context, "Error", "result.files.first.bytes is null. Please retry.");
      return;
    }
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => DisplaySvgPage(svgName, svgBytes)));
  }

  void _infoButtonPressed() async {
    final info = await PackageInfo.fromPlatform();
    showAboutDialog(
      context: context,
      applicationName: 'CCoSVG',
      applicationVersion: '${info.version} (${info.buildNumber})',
      applicationIcon: null,
      applicationLegalese: "©2023- lpubsppop01",
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "lpubsppop01/ccosvg",
                  style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse('https://github.com/lpubsppop01/ccosvg');
                      if (kIsWeb) {
                        // Use the plugin object directly because it didn't work as a plugin in the deployed site
                        var plugin = UrlLauncherPlugin();
                        if (await plugin.canLaunch(url.toString())) {
                          await plugin.launch(url.toString());
                        }
                      } else if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
