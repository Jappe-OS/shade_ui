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

import '../border_padding_presets.dart';

/// A basic container that should be placed straight on top of a background widget.
///
/// The recommended background color (to place this widget on) is `colorScheme.surface`.
/// Multiple [BasicContainer]s can be stacked on top of eachother.
@Deprecated("Use ShadeContainer instead.")
class BasicContainer extends StatefulWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const BasicContainer({Key? key, this.child, this.width, this.height, this.padding, this.decoration}) : super(key: key);

  @override
  _BasicContainerState createState() => _BasicContainerState();
}

class _BasicContainerState extends State<BasicContainer> {
  static const _bgColorDelta = 0.07;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: widget.decoration?.borderRadius == null
      ? (widget.decoration ?? const BoxDecoration()).copyWith(borderRadius: BorderRadius.circular(BPPresets.small), color: widget.decoration?.color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(_bgColorDelta) : Colors.white.withOpacity(_bgColorDelta)))
      : widget.decoration,
      child: widget.child,
    );
  }
}
