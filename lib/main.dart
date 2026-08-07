import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home.dart';
import 'pages/settings.dart';
import 'pages/sega_page.dart';
import 'pages/bandai_page.dart';
import 'pages/konami_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Bridge());
}

class Bridge extends StatelessWidget {
  const Bridge({super.key});

  static final defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          darkScheme = darkDynamic.harmonized();
        } else {
          lightScheme = defaultLightColorScheme;
          darkScheme = defaultDarkColorScheme;
        }

        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: ThemeData(
            colorScheme: lightScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
          ),
          home: Init(),
        );
      },
    );
  }
}

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
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
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/myaime_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                'assets/icons/myaime_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSecondaryContainer,
                  BlendMode.srcIn,
                ),
              ),
              label: 'SEGA',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note_outlined),
              selectedIcon: Icon(Icons.music_note),
              label: 'Bandai',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icons/e-amusement_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(
                'assets/icons/e-amusement_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSecondaryContainer,
                  BlendMode.srcIn,
                ),
              ),
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
