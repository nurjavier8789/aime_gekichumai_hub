import 'package:flutter/material.dart';

import '../widgets/navigation_control.dart';
import '../widgets/menu_webview.dart';

import 'package:shared_preferences/shared_preferences.dart';
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
    } else if (widget.game == "taiko") {
      navigateUri = "https://donderhiroba.jp/";
      titleAppBar = "Taiko No Tatsujin";
    } else if (widget.game == "taikoGuide") {
      navigateUri = "https://taiko.namco-ch.net/taiko/en/donhiro/guide/";
      titleAppBar = "Taiko No Tatsujin";
    } else if (widget.game == "sdvx") {
      navigateUri = "https://p.eagate.573.jp/game/sdvx";
      titleAppBar = "SOUND VOLTEX";
    } else if (widget.game == "sdvxExceed") {
      navigateUri = "https://p.eagate.573.jp/game/sdvx/vi";
      titleAppBar = "SOUND VOLTEX EXCEED GEAR";
    } else if (widget.game == "bms") {
      navigateUri = "https://p.eagate.573.jp/game/2dx";
      titleAppBar = "beatmania IIDX";
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
