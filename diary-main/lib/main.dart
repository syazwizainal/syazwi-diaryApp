import 'package:flutter/material.dart';
import 'dark_theme_provider.dart';
import 'pinScreen.dart';

void main() {
  runApp(const DarkThemeApp());
}

class DarkThemeApp extends StatefulWidget {
  const DarkThemeApp({Key? key}) : super(key: key);

  @override
  _DarkThemeAppState createState() => _DarkThemeAppState();
}

class _DarkThemeAppState extends State<DarkThemeApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DarkThemeProvider(
      isDarkMode: _isDarkMode,
      toggleDarkMode: _toggleDarkMode,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const PinScreen(),
        theme: _isDarkMode
            ? ThemeData.dark().copyWith(
                appBarTheme: const AppBarTheme(
                  color: Colors
                      .green, // Set your custom AppBar color for dark mode
                  iconTheme: IconThemeData(
                      color: Colors.white), // Customize the AppBar icon color
                ),
              )
            : ThemeData.light().copyWith(
                appBarTheme: const AppBarTheme(
                  color: Colors
                      .green, // Set your custom AppBar color for light mode
                  iconTheme: IconThemeData(
                      color: Colors.white), // Customize the AppBar icon color
                ),
              ),
      ),
    );
  }
}
