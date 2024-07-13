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

import '../border_padding_presets.dart';

/// Controls the border style of an [AdvancedContainer].
enum AdvancedContainerBorder {
  none,
  single,
  double,
}

/// Controls the background color of an [AdvancedContainer].
enum AdvancedContainerBackground {
  /// Use ontop of a container that uses `colorScheme.onBackground` as it's background color.
  /// [AdvancedContainer]s with `addOnBackground` can also be stacked on top of eachother if needed.
  addOnBackground,

  /// A default solid background color.
  solidBackground,

  /// A default background color with transprency.
  transparentBackground,

  /// Specify a custom color instead.
  custom,
}

// TODO: Blend border with accent if the backgroud color is accentified.
/// An advanced version of [BasicContainer] that provides more features and customizability.
class AdvancedContainer extends StatefulWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow> shadows;
  final AdvancedContainerBackground background;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final AdvancedContainerBorder borderStyle;
  final bool blur;

  const AdvancedContainer({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.shadows = const [],
    this.background = AdvancedContainerBackground.addOnBackground,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = BPPresets.small,
    this.borderStyle = AdvancedContainerBorder.none,
    this.blur = false,
  }) : super(key: key);

  AdvancedContainer copyWith({
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    List<BoxShadow>? shadows,
    AdvancedContainerBackground? background,
    Color? backgroundColor,
    Color? borderColor,
    double? borderRadius,
    AdvancedContainerBorder? borderStyle,
    bool? blur,
  }) {
    return AdvancedContainer(
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      background: background ?? this.background,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderStyle: borderStyle ?? this.borderStyle,
      blur: blur ?? this.blur,
      child: child ?? this.child,
    );
  }

  @override
  _AdvancedContainerState createState() => _AdvancedContainerState();
}

class _AdvancedContainerState extends State<AdvancedContainer> {
  static const _bgColorDelta = 0.07;

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadows = [];

    for (var shadow in widget.shadows) {
      shadows.add(BoxShadow(
        color: shadow.color,
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
        blurStyle: BlurStyle.outer,
      ));
    }

    Widget container() {
      return Container(
          width: widget.width,
          height: widget.height,
          decoration: widget.borderStyle == AdvancedContainerBorder.double
              ? BoxDecoration(
                  border: widget.borderStyle == AdvancedContainerBorder.double
                      ? Border.all(
                          color: Colors.black.withOpacity(0.7),
                          width: 1.0,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null,
                  borderRadius: widget.borderStyle == AdvancedContainerBorder.double ? BorderRadius.all(Radius.circular(widget.borderRadius)) : null,
                  boxShadow: shadows,
                )
              : const BoxDecoration(),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: () {
                switch (widget.background) {
                  case AdvancedContainerBackground.addOnBackground:
                    return (Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(_bgColorDelta)
                        : Colors.white.withOpacity(_bgColorDelta));
                  case AdvancedContainerBackground.solidBackground:
                    return Theme.of(context).colorScheme.background;
                  case AdvancedContainerBackground.transparentBackground:
                    return Theme.of(context).colorScheme.background.withOpacity(0.85);
                  case AdvancedContainerBackground.custom:
                    return widget.backgroundColor;
                }
              }(),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
              border: () {
                if (widget.borderStyle == AdvancedContainerBorder.single) {
                  return Border.all(color: widget.borderColor ?? Theme.of(context).dividerColor, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside);
                } else if (widget.borderStyle == AdvancedContainerBorder.double) {
                  return Border.all(
                    color: widget.borderColor ?? (Theme.of(context).colorScheme.onInverseSurface.scale(lightness: 0.05)),
                    width: 1.0,
                    strokeAlign: BorderSide.strokeAlignInside,
                  );
                }

                return null;
              }(),
              image: widget.blur ? const DecorationImage(
                image: AssetImage(
                  "resources/images/blur_noise.png",
                  package: "shade_ui",
                ),
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat,
                scale: 7,
                opacity: 0.038,
              ) : null,
            ),
            child: widget.child,
          ),
        );
    }

    return widget.blur ? ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0, tileMode: TileMode.repeated),
        child: container(),
      ),
    ) : container();
  }
}
