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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';

/// A menu strip that contains horizantally stacked items, by ShadeUI.
class ShadeMenuStrip extends StatefulWidget {
  /// Title:
  /// - "&&sep": Creates a separator.
  final List<ShadeMenuStripItem> items;

  const ShadeMenuStrip({Key? key, required this.items}) : super(key: key);

  @override
  _ShadeMenuStripState createState() => _ShadeMenuStripState();
}

/// The [State] class for [ShadeMenuStrip].
class _ShadeMenuStripState extends State<ShadeMenuStrip> {
  List<PlutoMenuItem> itemWidgets = [];

  @override
  Widget build(BuildContext context) {
    itemWidgets.clear();
    itemWidgets = _loop(widget.items);

    return PlutoMenuBar(
      height: 35,
      mode: PlutoMenuBarMode.hover,
      menus: itemWidgets,
    );
  }

  List<PlutoMenuItem> _loop(List<ShadeMenuStripItem> l) {
    List<PlutoMenuItem> local = [];

    for (ShadeMenuStripItem msi in l) {
      // Other types than buttons
      if (msi.title == "&&sep") {
        local.add(PlutoMenuItem.divider());
      }
      // Button
      else {
        // Check children
        List<PlutoMenuItem>? children;
        if (msi.children != null && msi.children != null ? msi.children!.isNotEmpty : false) {
          children = _loop(msi.children ?? []);
        }

        // Add to local
        local.add(PlutoMenuItem(title: msi.title, onTap: msi.onTap, children: children));
      }
    }

    return local;
  }
}

/// Item for a menu strip. If [children] is not null, onTap should be null and vice versa.
class ShadeMenuStripItem {
  final String title;
  final List<ShadeMenuStripItem>? children;
  final Function()? onTap;

  ShadeMenuStripItem(this.title, this.onTap, this.children);

  /// Make a separator item to make UI look cleaner.
  static ShadeMenuStripItem separator() => ShadeMenuStripItem("&&sep", null, null);
}