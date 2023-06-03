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
import 'package:shade_ui/widgets/base.dart';
import 'package:shade_ui/widgets/buttons/shade_button.dart';

/// An item that is used within the [ShadeButtonBar] widget.
class ShadeButtonBarItem {
  String? text;
  IconData? icon;
  void Function()? action;

  ShadeButtonBarItem({this.text, this.icon, this.action});
}

/// A button bar that can contain multiple buttons, by ShadeUI.
class ShadeButtonBar extends StatefulWidget {
  /// The items that the bar will contain.
  final List<ShadeButtonBarItem> items;

  /// The index of the item that is selected at first, defaults to 0.
  final int defaultSelected;

  const ShadeButtonBar(this.items, [this.defaultSelected = 0]);

  @override
  _ShadeButtonBarState createState() => _ShadeButtonBarState();
}

/// The [State] class for [ShadeButtonBar].
class _ShadeButtonBarState extends State<ShadeButtonBar> {
  int? selected;
  List<ShadeButton> buttons = [];

  @override
  Widget build(BuildContext context) {
    if (selected == null) setSelected(widget.defaultSelected);

    return Row(
      children: buttons,
    );
  }

  // Set selected item
  void setSelected(int sel) {
    setState(() {
      selected = sel;
      setButtons();
    });
  }

  // Re-set the button widgets
  void setButtons() {
    buttons.clear();

    for (int index = 0; index < widget.items.length; index++) {
      final ShadeButtonBarItem item = widget.items[index];
      ShadeBorderRadius sbr = ShadeBorderRadius.none();

      if (index == 0) {
        sbr = ShadeBorderRadius(true, false, true, false);
      } else if (index == widget.items.length - 1) {
        sbr = ShadeBorderRadius(false, true, false, true);
      }

      buttons.add(ShadeButton(
        text: item.text,
        icon: item.icon,
        isPrimary: index == selected,
        borderRadius: sbr,
        onPress: () {
          setSelected(index);
          if (item.action != null) item.action!();
        },
      ));
    }
  }
}
