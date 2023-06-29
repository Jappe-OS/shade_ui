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
import 'package:shade_theming/main.dart';

/// A straight line.
class ShadeDivider extends StatefulWidget {
  const ShadeDivider({Key? key}) : super(key: key);

  @override
  _ShadeDividerState createState() => _ShadeDividerState();
}

/// The [State] class for [ShadeDivider].
class _ShadeDividerState extends State<ShadeDivider> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().borderColor,
    );
  }
}
