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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shade_ui/colors.dart';

/// Controls the border style of a [ShadeContainer].
enum ShadeContainerBorder {
  none,
  single,
  double,
}

/// Defines the type of background. Used for checking whether a transparent color is needed.
enum _ShadeContainerBackgroundType {
  solid,
  transparent,
}

/// A container widget that makes it easier to craft UI.
class ShadeContainer extends StatefulWidget {
  /// Contructs a solid container without any transparency. The default color is [Theme.of(context).colorScheme.surface].
  factory ShadeContainer.solid({Widget? child, double? width, double? height, EdgeInsets? padding, Color? backgroundColor, ShadeContainerBorder border = ShadeContainerBorder.none, double? borderRadius, List<BoxShadow> shadows = const []}) {
    final newBackgroundColor = backgroundColor?.withOpacity(1); 
    return ShadeContainer._(width: width, height: height, padding: padding, backgroundColor: newBackgroundColor, backgroundType: _ShadeContainerBackgroundType.solid, border: border, borderRadius: borderRadius, shadows: shadows, child: child);
  }

  /// Contructs a transparent container, optionally with blur. The default color is [Theme.of(context).colorScheme.surface.transparentVersion()].
  factory ShadeContainer.transparent({Widget? child, double? width, double? height, EdgeInsets? padding, Color? backgroundColor, bool backgroundBlur = false, ShadeContainerBorder border = ShadeContainerBorder.none, double? borderRadius, List<BoxShadow> shadows = const []}) {
    final newBackgroundColor = backgroundColor?.transparentVersion(); 
    return ShadeContainer._(width: width, height: height, padding: padding, backgroundColor: newBackgroundColor, backgroundBlur: backgroundBlur, backgroundType: _ShadeContainerBackgroundType.transparent, border: border, borderRadius: borderRadius, shadows: shadows, child: child);
  }

  const ShadeContainer._({
    this.child,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.backgroundBlur = false,
    required this.backgroundType,
    required this.border,
    this.borderRadius,
    this.shadows = const []});

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool backgroundBlur;
  final _ShadeContainerBackgroundType backgroundType;
  final ShadeContainerBorder border;
  final double? borderRadius;
  final List<BoxShadow> shadows;

  @override
  _AdvancedContainerState createState() => _AdvancedContainerState();
}

class _AdvancedContainerState extends State<ShadeContainer> {
  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadows = [];

    // Configure shadows.
    for (var shadow in widget.shadows) {
      shadows.add(BoxShadow(
        color: shadow.color,
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
        blurStyle: BlurStyle.outer,
      ));
    }

    final outerBorderColor = Colors.black.withOpacity(0.7);
    final innerBorderColor = Theme.of(context).colorScheme.onInverseSurface.blend(Colors.white, 0.3);

    // The container widget.
    Widget container() {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: widget.border == ShadeContainerBorder.double ? Border.all(
            color: outerBorderColor,
            width: 1.0,
            strokeAlign: BorderSide.strokeAlignOutside,
          ) : null,
          borderRadius: widget.borderRadius != null ? BorderRadius.circular(widget.borderRadius!) : null,
          boxShadow: shadows,
          image: widget.backgroundBlur ? const DecorationImage(
            image: AssetImage(
              "resources/images/blur_noise.png",
              package: "shade_ui",
            ),
            fit: BoxFit.none,
            repeat: ImageRepeat.repeat,
            scale: 7,
            opacity: 0.038,
          ) : null,
          color: () {
            if (widget.backgroundColor == null) {
              switch (widget.backgroundType) {
                case _ShadeContainerBackgroundType.solid:
                  return Theme.of(context).colorScheme.surface;
                case _ShadeContainerBackgroundType.transparent:
                  return Theme.of(context).colorScheme.surface.transparentVersion();
              }
            }

            return widget.backgroundColor;
          }(),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: widget.borderRadius != null ? BorderRadius.circular(widget.borderRadius!) : null,
          border: () {
            if (widget.border == ShadeContainerBorder.single) {
              return Border.all(color: Theme.of(context).dividerColor, width: 1.0, strokeAlign: BorderSide.strokeAlignInside);
            } else if (widget.border == ShadeContainerBorder.double) {
              return Border.all(
                color: innerBorderColor,
                width: 0.5,
                strokeAlign: BorderSide.strokeAlignInside + 0.5,
              );
            }

            return null;
          }(),
        ),
        child: widget.padding != null ? Padding(padding: widget.padding!, child: widget.child) : widget.child,
      );
    }

    // Additional padding needed to display outher border.
    final additionalPaddingForClipRRect = widget.border == ShadeContainerBorder.double ? 1.0 : 0.0;

    // Return the container() differently depending on blur.
    return widget.backgroundBlur ? ClipRRect(
      borderRadius: widget.borderRadius != null ? BorderRadius.circular(widget.borderRadius! + additionalPaddingForClipRRect) : BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0, tileMode: TileMode.repeated),
        child: Padding(padding: EdgeInsets.all(additionalPaddingForClipRRect), child: container()),
      ),
    ) : container();
  }
}
