//  ShadeUI, A UI system for JappeOS apps.
//  Copyright (C) 2024  The JappeOS team.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import 'shade_theme_primary.dart';

/// Manages customised theme properties that modify the look of the UI.
///
/// * **Use this class in UI:**
///
/// The following example shows a way to listen to theme changes
/// (mostly used in custom widgets), and a way to set theme
/// properties runtime and notify all listeners.
///
/// ```dart
/// var themeProvider = Provider.of<ShadeCustomThemeProperties>(context);
///
/// //...
///
/// // To listen
/// /*...*/themeProvider.accent;
/// // To set
/// /*...*/themeProvider.accent = ShadeThemeAccent.blue;
/// ```
class ShadeCustomThemeProperties extends ChangeNotifier {
  ThemeMode? _themeMode;
  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  Color? _primary;
  Color get primary => _primary ?? ShadeThemePrimary.blue;
  set accent(Color primary) {
    _primary = primary;
    notifyListeners();
  }

  bool? _accentifyColors;
  bool get accentifyColors => _accentifyColors ?? false;
  set accentifyColors(bool accentify) {
    _accentifyColors = accentify;
    notifyListeners();
  }

  ShadeCustomThemeProperties(this._themeMode, this._primary, this._accentifyColors);

  factory ShadeCustomThemeProperties.setDefault() => ShadeCustomThemeProperties(null, null, null);
}