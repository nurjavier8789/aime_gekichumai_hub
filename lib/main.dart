import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home.dart';
import 'pages/settings.dart';
import 'pages/sega_page.dart';
import 'pages/bandai_page.dart';
import 'pages/konami_page.dart';

void main() {
  runApp(bridge());
}

class bridge extends StatelessWidget {
  const bridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorScheme.of(context).onPrimary,
          brightness: Brightness.light
        ),
        useSystemColors: true,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorScheme.of(context).onPrimary,
          brightness: Brightness.dark
        ),
        useSystemColors: true,
        useMaterial3: true,
      ),
      home: init(),
    );
  }
}

class init extends StatefulWidget {
  const init({super.key});

  @override
  State<init> createState() => _initState();
}

class _initState extends State<init> {
  int selectedIndex = 0;

  void startUpAppCheck() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getDouble("zoomLevel") == null) {
      prefs.setDouble("zoomLevel", 1.0);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: selectedIndex,
              children: <Widget>[
                HomePage(),
                sega_page(),
                bandai_page(),
                konami_page(),
                SettingsPage()
              ],
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note_outlined),
              selectedIcon: Icon(Icons.music_note),
              label: 'SEGA',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note_outlined),
              selectedIcon: Icon(Icons.music_note),
              label: 'Bandai',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note_outlined),
              selectedIcon: Icon(Icons.music_note),
              label: 'Konami',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedIndex: selectedIndex,
        ),
      );
  }
}
