import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/settings.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: selectedIndex,
              children: const <Widget>[
                HomePage(),
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
