import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  Brightness _mode;
  ThemeChanger(this._themeData, this._mode);

  getTheme() => _themeData;
  getMode() => _mode;
  setTheme(ThemeData theme, Brightness mode) {
    _themeData = theme;
    _mode = mode;
    notifyListeners();
  }
}