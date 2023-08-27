//  ShadeUI, A UI system for JappeOS apps.
//  Copyright (C) 2023  The JappeOS team.
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

TextTheme createTextTheme(Color textColor) {
  return TextTheme(
    displayLarge: _ShadeTextStyle(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      textColor: textColor,
    ),
    displayMedium: _ShadeTextStyle(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      textColor: textColor,
    ),
    displaySmall: _ShadeTextStyle(
      fontSize: 48,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineLarge: _ShadeTextStyle(
      fontSize: 40,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineMedium: _ShadeTextStyle(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    headlineSmall: _ShadeTextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    titleLarge: _ShadeTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    titleMedium: _ShadeTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    titleSmall: _ShadeTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    bodyLarge: _ShadeTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    bodyMedium: _ShadeTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    bodySmall: _ShadeTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    labelLarge: _ShadeTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      textColor: textColor,
    ),
    labelMedium: _ShadeTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
    labelSmall: _ShadeTextStyle(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      textColor: textColor,
    ),
  );
}

class _ShadeTextStyle extends TextStyle {
  final Color textColor;
  const _ShadeTextStyle({
    super.fontSize,
    super.fontWeight,
    required this.textColor,
  }) : super(
          fontFamily: 'Nunito',
          package: 'shade_ui',
          color: textColor,
        );
}