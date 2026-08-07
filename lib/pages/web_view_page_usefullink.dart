import 'package:flutter/material.dart';

import '../widgets/navigation_control.dart';
import '../widgets/menu_webview.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageUsefullink extends StatefulWidget {
  const WebViewPageUsefullink({super.key, required this.whatdoyouwant});

  final String whatdoyouwant;

  @override
  State<WebViewPageUsefullink> createState() => _WebViewPageUsefullinkState();
}

class _WebViewPageUsefullinkState extends State<WebViewPageUsefullink> {
  var loadingPercentage = 0;
  String navigateUri = "";
  String titleAppBar = "";
  late final WebViewController controller;
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

    if (widget.whatdoyouwant == "song_list") {
      navigateUri = "https://arcade-songs.zetaraku.dev/";
      titleAppBar = "Arcade songs by zetaraku";
    } else if (widget.whatdoyouwant == "arcade_locator") {
      navigateUri = "https://zenius-i-vanisher.com/v5.2/arcades.php";
      titleAppBar = "Arcade Locator";
    }

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
          controller.runJavaScript("document.body.style.zoom = '$_zoomLevel';");
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