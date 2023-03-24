import 'package:ccosvg/helpers/show_message.dart';
import 'package:ccosvg/widgets/display_svg_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
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
                              text: TextSpan(children: [
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
                                  }),
                          ])))
                    ]);
              },
              icon: const Icon(Icons.info)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  var result = await FilePicker.platform.pickFiles();
                  if (result == null) {
                    showMessage(context, "Error", "FilePicker.platform.pickFiles() returned null. Please retry.");
                    return;
                  }
                  var svgBytes = result.files.first.bytes;
                  if (svgBytes == null) {
                    showMessage(context, "Error", "result.files.first.bytes is null. Please retry.");
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute<void>(builder: (context) => DisplaySvgPage(svgBytes)));
                },
                child: const Text('Open SVG File'))
          ],
        ),
      ),
    );
  }
}
