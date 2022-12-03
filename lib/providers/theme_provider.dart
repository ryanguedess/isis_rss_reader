import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeData _darkTheme =
      ThemeData.from(colorScheme: const ColorScheme.dark()).copyWith(
          useMaterial3: true,
);

  final ThemeData _lightTheme =
      ThemeData.from(colorScheme: const ColorScheme.light()).copyWith(
          useMaterial3: true,
);

  bool isDarkTheme = true;

  ThemeData getTheme() {
    if (isDarkTheme) {
      return _darkTheme;
    } else {
      return _lightTheme;
    }
  }

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
