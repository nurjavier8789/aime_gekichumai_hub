import 'package:flutter/material.dart';

import '../widgets/navigation_control.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageMyAime extends StatefulWidget {
  const WebViewPageMyAime({super.key, required this.regionVersion, required this.game});

  final String regionVersion;
  final String game;

  @override
  State<WebViewPageMyAime> createState() => _WebViewPageMyAimeState();
}

class _WebViewPageMyAimeState extends State<WebViewPageMyAime> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()..loadRequest(Uri.parse("https://my-aime.net/en/"));
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
          actions: [
            NavigationControls(controller: controller)
          ],
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      );
  }
}
