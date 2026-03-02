import 'package:flutter/material.dart';

import '../widgets/navigation_control.dart';
import '../widgets/menu_webview.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageGekiChuMai extends StatefulWidget {
  const WebViewPageGekiChuMai({super.key, required this.regionVersion, required this.game});

  final String regionVersion;
  final String game;

  @override
  State<WebViewPageGekiChuMai> createState() => _WebViewPageGekiChuMaiState();
}

class _WebViewPageGekiChuMaiState extends State<WebViewPageGekiChuMai> {
  var loadingPercentage = 0;
  String navigateUri = "";
  String titleAppBar = "";
  late final WebViewController controller;

  @override
  void initState() {
    if (widget.regionVersion == "GLOBAL" && widget.game == "maimai") {
      navigateUri = "https://maimaidx-eng.com/maimai-mobile";
      titleAppBar = "maimai DX";
    } else if (widget.regionVersion == "GLOBAL" && widget.game == "chunithm") {
      navigateUri = "https://chunithm-net-eng.com/mobile";
      titleAppBar = "CHUNITHM";
    } else if (widget.regionVersion == "JAPAN" && widget.game == "maimai") {
      navigateUri = "https://maimaidx.jp/maimai-mobile";
      titleAppBar = "maimai DX";
    } else if (widget.regionVersion == "JAPAN" && widget.game == "chunithm") {
      navigateUri = "https://new.chunithm-net.com";
      titleAppBar = "CHUNITHM";
    } else if (widget.regionVersion == "JAPAN" && widget.game == "ongeki") {
      navigateUri = "https://ongeki-net.com/ongeki-mobile";
      titleAppBar = "O.N.G.E.K.I.";
    }

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
      ..loadRequest(Uri.parse(navigateUri))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titleAppBar),
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
