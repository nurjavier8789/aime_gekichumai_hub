import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'aboutApp.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final WebViewController controller;

  Future<void> checkForUpdates(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking for updates...')),
    );

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final url = Uri.parse('https://api.github.com/repos/nurjavier8789/amuse-link/releases');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final latestRelease = data[0];

          String latestVersion = latestRelease['tag_name'];
          bool isPreRelease = latestRelease['prerelease']; 

          if (!mounted) return;

          if (currentVersion != latestVersion) {
            String status = isPreRelease ? "(Pre-Release/Beta)" : "(Stable)";

            showUpdateDialog(context, "$latestVersion $status", latestRelease['html_url']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You\'re using latest version!')),
            );
          }
        }
      } else {
        throw Exception('Gagal menghubungi GitHub');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengecek update: $e')),
      );
    }
  }

  void showUpdateDialog(BuildContext context, String newVersion, String urlUpdate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Available!'),
          content: Text('Version $newVersion is now available. Do you want to update it now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);

                final Uri githubUri = Uri.parse(urlUpdate);

                if (await canLaunchUrl(githubUri)) {
                  await launchUrl(githubUri, mode: LaunchMode.externalApplication);
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to open browser.')),
                  );
                }
              },
              child: const Text('Download Now'),
            ),
          ],
        );
      },
    );
  }

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
                    icon: const Icon(Icons.remove, size: 32),
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
                    icon: const Icon(Icons.add, size: 32),
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
                        const SnackBar(content: Text('Zoom level has been saved!')),
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
              thickness: 2,
            ),
            ElevatedButton.icon(
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
              icon: Icon(Icons.delete, size: 24),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text("Clear Cookies", style: TextStyle(fontSize: 18, fontFamily: "Google Sans", color: Colors.white)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showZoomDialog();
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              icon: Icon(Icons.zoom_in, size: 24),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text("Edit zoom page", style: TextStyle(fontSize: 18, fontFamily: "Google Sans", color: Colors.white)),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            ElevatedButton.icon(
              onPressed: () {
                checkForUpdates(context);
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              icon: Icon(Icons.new_releases, size: 24),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text("Check for update", style: TextStyle(fontSize: 18, fontFamily: "Google Sans", color: Colors.white)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutApp()));
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                shadowColor: const Color.fromRGBO(0, 0, 0, 0),
                shape: LinearBorder(),
              ),
              icon: Icon(Icons.info_outline, size: 24),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text("About", style: TextStyle(fontSize: 18, fontFamily: "Google Sans", color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
