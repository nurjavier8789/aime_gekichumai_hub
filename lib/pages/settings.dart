import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final WebViewController controller;

  Future<void> showZoomDialog() async {
    final prefs = await SharedPreferences.getInstance();
    double currentZoom = prefs.getDouble('zoomLevel') ?? 1.0;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit zoom page'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 32),
                    color: Colors.red,
                    onPressed: () {
                      if (currentZoom > 0.4) {
                        setStateDialog(() {
                          currentZoom -= 0.2;
                        });
                      }
                    },
                  ),
                  Text(
                    '${(currentZoom * 100).round()}%', 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 32),
                    color: Colors.green,
                    onPressed: () {
                      setStateDialog(() {
                        currentZoom += 0.2;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    await prefs.setDouble('zoomLevel', currentZoom);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengaturan zoom berhasil disimpan!')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Settings"),
      ),
      body: Center(
        child: ListView(
          children: [
            Divider(
              color: Colors.blueGrey,
              thickness: 2,
            ),
            ElevatedButton(
              onPressed: () async {
                final cookieManager = WebViewCookieManager();

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
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Clear Cookies", style: TextStyle(fontSize: 16, fontFamily: "Google Sans")),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                showZoomDialog();
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Edit zoom page", style: TextStyle(fontSize: 16, fontFamily: "Google Sans")),
              ),
            ),
            Divider(
              color: const Color.fromARGB(100, 96, 125, 139),
              thickness: 1,
            ),
            ElevatedButton(
              onPressed: () async {
                // WIP
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("About", style: TextStyle(fontSize: 16, fontFamily: "Google Sans")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
