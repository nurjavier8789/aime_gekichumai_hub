import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  clearCookies,
}

class MenuWebview extends StatefulWidget {
  const MenuWebview({super.key, required this.controller});

  final WebViewController controller;

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
        }
      },
      itemBuilder: (context) => [
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
