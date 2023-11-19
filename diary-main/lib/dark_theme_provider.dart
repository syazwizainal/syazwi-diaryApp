import 'package:flutter/material.dart';

class DarkThemeProvider extends InheritedWidget {
  final bool isDarkMode;
  final VoidCallback toggleDarkMode;

  DarkThemeProvider({
    required this.isDarkMode,
    required this.toggleDarkMode,
    required Widget child,
  }) : super(child: child);

  static DarkThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DarkThemeProvider>();
  }

  @override
  bool updateShouldNotify(DarkThemeProvider oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
}
