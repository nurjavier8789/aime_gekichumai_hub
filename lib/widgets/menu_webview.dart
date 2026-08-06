import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  clearCookies,
  findInPage,
  zoomIn,
  zoomOut,
}

class MenuWebview extends StatefulWidget {
  const MenuWebview({
    super.key,
    required this.controller,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onSearch,
  });

  final WebViewController controller;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onSearch;

  @override
  State<MenuWebview> createState() => _MenuWebviewState();
}

class _MenuWebviewState extends State<MenuWebview> {
  final cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.clearCookies:
            await _onClearCookies();
            break;
          case _MenuOptions.findInPage:
            widget.onSearch();
            break;
          case _MenuOptions.zoomIn:
            widget.onZoomIn();
            break;
          case _MenuOptions.zoomOut:
            widget.onZoomOut();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.zoomIn,
          child: Text('Zoom In (+)'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.zoomOut,
          child: Text('Zoom Out (-)'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.findInPage,
          child: Text('Find in page'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
      ],
    );
  }

  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
