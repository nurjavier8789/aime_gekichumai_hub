import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String appName = "...";
  String appVersion = "...";

  Future<void> loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "${packageInfo.version} (${packageInfo.updateTime.toString().split('.')[0]})";
      appName = packageInfo.appName;
    });
  }

  @override
  void initState() {
    loadVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(child: Text(appName, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
          Text("Version $appVersion"),
          SizedBox(height: 18),
          Text("Credits", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Text("Zetaraku - arcade-songs"),
          Text("zenius-i-vanisher"),
        ],
      ),
    );
  }
}