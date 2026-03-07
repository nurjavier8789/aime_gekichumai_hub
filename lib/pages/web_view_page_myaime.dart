import 'package:flutter/material.dart';

import '../widgets/navigation_control.dart';
import '../widgets/menu_webview.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageMyAime extends StatefulWidget {
  const WebViewPageMyAime({super.key});

  @override
  State<WebViewPageMyAime> createState() => _WebViewPageMyAimeState();
}

class _WebViewPageMyAimeState extends State<WebViewPageMyAime> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse("https://my-aime.net/en/"))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Aime"),
          actions: [
            NavigationControls(controller: controller),
            MenuWebview(controller: controller)
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100,
              ),
          ],
        ),
      );
  }
}
