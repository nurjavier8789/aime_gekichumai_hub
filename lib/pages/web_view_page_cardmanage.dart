import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/navigation_control.dart';
import '../widgets/menu_webview.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageCardManage extends StatefulWidget {
  const WebViewPageCardManage({super.key, required this.provider});

  final String provider;

  @override
  State<WebViewPageCardManage> createState() => _WebViewPageCardManageState();
}

class _WebViewPageCardManageState extends State<WebViewPageCardManage> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  String navigateUri = "";
  String titleAppBar = "";
  double _zoomLevel = 1;
  bool isSearching = false; 
  final TextEditingController searchController = TextEditingController();

  void setInitZoomLevel() async {
    final prefs = await SharedPreferences.getInstance();

    _zoomLevel = prefs.getDouble("zoomLevel")!;
  }

  @override
  void initState() {
    setInitZoomLevel();
    
    if (widget.provider == "myAime") {
      navigateUri = "https://my-aime.net/en/";
      titleAppBar = "My Aime";
    } else if (widget.provider == "banapass") {
      navigateUri = "https://banapass.net/card/list";
      titleAppBar = "Bandai Namco Passport";
    } else if (widget.provider == "eamusement") {
      navigateUri = "https://p.eagate.573.jp/gate/eapass/menu.html";
      titleAppBar = "e-amusement pass";
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
          controller.runJavaScript("document.body.style.zoom = '$_zoomLevel';");
        },
      ))
      ..loadRequest(Uri.parse(navigateUri))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    
    super.initState();
  }

  void _zoomIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _zoomLevel += 0.2;
      prefs.setDouble("zoomLevel", _zoomLevel);
    });
    controller.runJavaScript("document.body.style.zoom = '$_zoomLevel';");
  }

  void _zoomOut() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_zoomLevel > 0.4) {
        _zoomLevel -= 0.2;
        prefs.setDouble("zoomLevel", _zoomLevel);
      }
    });
    controller.runJavaScript("document.body.style.zoom = '$_zoomLevel';");
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void findInPage(bool backwards) async {
    String text = searchController.text.replaceAll("'", "\\'");
    if (text.isNotEmpty) {
      final Object result = await controller.runJavaScriptReturningResult(
        "window.find('$text', false, $backwards, true);"
      );

      bool isFound = (result == true || result.toString() == 'true');

      if (!isFound) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oops... Not found...'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
    });
    controller.runJavaScript("window.getSelection().removeAllRanges();");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (await controller.canGoBack()) {
          await controller.goBack();
        } else {
          if (context.mounted) {
            Navigator.of(context).pop(result);
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
            title: isSearching
              ? TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Find in page...',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => findInPage(false),
                )
              : Text(titleAppBar),
            actions: isSearching 
            ? [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up),
                onPressed: () => findInPage(true),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: () => findInPage(false),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: stopSearch,
              ),
            ]
            : [
              NavigationControls(controller: controller),
              MenuWebview(
                controller: controller,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
                onSearch: startSearch,
              ),
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
                  borderRadius: BorderRadius.circular(12),
                  minHeight: 6,
                ),
            ],
          ),
        ),
    );
  }
}
