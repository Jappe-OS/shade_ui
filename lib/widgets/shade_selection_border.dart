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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

/// A selection that should wrap a [Container] or a similar widget.
/// This widget should have the same border radius as the child widget.
class ShadeSelectionBorder extends StatefulWidget {
  final BorderRadiusGeometry borderRadius;
  final bool isHighlighted;
  final Widget child;

  const ShadeSelectionBorder({Key? key, this.borderRadius = BorderRadius.zero, this.isHighlighted = false, required this.child}) : super(key: key);

  @override
  _ShadeSelectionBorderState createState() => _ShadeSelectionBorderState();
}

class _ShadeSelectionBorderState extends State<ShadeSelectionBorder> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    late Color borderColor;

    if (isHovered) {
      borderColor = Theme.of(context).colorScheme.primary;
    } else if (widget.isHighlighted) {
      borderColor = Theme.of(context).colorScheme.secondary;
    } else {
      borderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, strokeAlign: BorderSide.strokeAlignOutside, color: borderColor),
        borderRadius: widget.borderRadius,
      ),
      child: MouseRegion(
        onEnter: (p0) => setState(() => isHovered = true),
        onExit: (p0) => setState(() => isHovered = false),
        child: widget.child,
      ),
    );
  }
}
