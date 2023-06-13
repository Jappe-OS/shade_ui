//  ShadeUI, An UI elements package for JappeOS apps.
//  Copyright (C) 2022  Jappe02
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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shade_theming/shade_theming.dart';

import '../../utils.dart';

/// A slider that can hold a float/double value, by ShadeUI.
class ShadeSlider extends StatefulWidget {
  /// The current value of the slider, thumb is drawn at a position
  /// that corresponds to this value.
  final double value;

  /// Minimum value of the slider.
  final double min;

  /// Maximum value of the slider.
  final double max;

  /// Automatically focuses the slider.
  final bool autoFocus;

  /// Divides slider into multiple parts.
  final int? divisions;

  /// This [Function] is called when the value of the slider changes.
  final void Function(double) onChanged;

  const ShadeSlider({Key? key, required this.value, this.min = 0.0, this.max = 0.1, this.autoFocus = false, this.divisions, required this.onChanged})
      : super(key: key);

  @override
  _ShadeSliderState createState() => _ShadeSliderState();
}

/// The [State] class for [ShadeSlider].
class _ShadeSliderState extends State<ShadeSlider> {
  @override
  Widget build(BuildContext context) {
    Color accent = context.watch<ShadeThemeProvider>().getCurrentThemeProperties().accentColor;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: SHUI_SINGLE_LINE_ELEMENT_HEIGHT,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 0.0,
          disabledThumbRadius: 0.0,
        ),
      ),
      child: Slider(
        value: widget.value,
        min: widget.min,
        max: widget.max,
        autofocus: widget.autoFocus,
        divisions: widget.divisions,
        thumbColor: accent,
        activeColor: accent,
        inactiveColor: accent.withOpacity(0.7),
        secondaryActiveColor: Colors.white.withOpacity(0.5),
        mouseCursor: SystemMouseCursors.alias,
        onChanged: widget.onChanged,
      ),
    );
  }
}
