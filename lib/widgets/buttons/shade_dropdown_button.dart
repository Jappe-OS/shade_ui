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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shade_theming/shade_theming.dart';
import 'package:shade_ui/utils.dart';

import '../text/shade_text.dart';

/// A dropdown button that can used to select a single item from multiple.
class ShadeDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const ShadeDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SHUI_DEFAULT_BORDER_RADIUS),
        color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().transparentFillColor,
      ),
      child: Padding(padding: EdgeInsets.only(top: 5, bottom: 5, left: 13, right: 13), child:DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        underline: null,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: ShadeText(
              text: item.toString(),
              customColor: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().normalTextColor,
              style: ShadeTextStyle.normal,
            ),
          );
        }).toList(),
      ),),
    );
  }
}