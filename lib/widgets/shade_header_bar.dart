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

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shade_ui/colors.dart';
import 'package:shade_ui/extensions.dart';
import 'package:shade_ui/shade_ui.dart';

const _defaultHeaderBarHeight = 35.0;
const _populatedHeaderbarHeight = 45.0;

class ShadeHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  /// The primary title widget.
  final Widget? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// Widgets to display after the [title] widget.
  final List<Widget>? actions;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double? titleSpacing;

  /// The background color.
  final Color? backgroundColor;

  /// Whether the title bar is visualized as active.
  final bool? isActive;

  /// Whether the title bar shows a close button.
  final bool? isClosable;

  /// Whether the title bar can be dragged.
  final bool? isDraggable;

  /// Whether the title bar shows a maximize button.
  final bool? isMaximizable;

  /// Whether the title bar shows a minimize button.
  final bool? isMinimizable;

  /// Whether the title bar shows a restore button.
  final bool? isRestorable;

  /// Called when the close button is pressed.
  final FutureOr<void> Function(BuildContext)? onClose;

  /// Called when the title bar dragging begins.
  final FutureOr<void> Function(BuildContext)? onDragStart;

  /// Called when the title bar dragging ends.
  final FutureOr<void> Function(BuildContext)? onDragEnd;

  /// Called when the title bar is dragged to move the window.
  final FutureOr<void> Function(BuildContext, DragUpdateDetails)? onDrag;

  /// Called when the maximize button is pressed or the title bar is
  /// double-clicked while the window is not maximized.
  final FutureOr<void> Function(BuildContext)? onMaximize;

  /// Called when the minimize button is pressed.
  final FutureOr<void> Function(BuildContext)? onMinimize;

  /// Called when the restore button is pressed or the title bar is
  /// double-clicked while the window is maximized.
  final FutureOr<void> Function(BuildContext)? onRestore;

  /// Called when the secondary mouse button is pressed.
  final FutureOr<void> Function(BuildContext)? onShowMenu;

  /// The tag to use for the [Hero] wrapping the window controls.
  ///
  /// By default, a unique tag is used to ensure that the window controls stay
  /// in place during page transitions. If set to `null`, no [Hero] will be used.
  final Object? heroTag;

  @override
  Size get preferredSize => Size(0, (leading == null && actions == null) ? _defaultHeaderBarHeight : _populatedHeaderbarHeight);

  const ShadeHeaderBar(
      {super.key,
      this.title,
      this.leading,
      this.actions,
      this.centerTitle = true,
      this.titleSpacing,
      this.backgroundColor,
      this.isActive,
      this.isClosable,
      this.isDraggable,
      this.isMaximizable,
      this.isMinimizable,
      this.isRestorable,
      this.onClose,
      this.onDragStart,
      this.onDragEnd,
      this.onDrag,
      this.onMaximize,
      this.onMinimize,
      this.onRestore,
      this.onShowMenu,
      this.heroTag});

  @override
  _ShadeHeaderBarState createState() => _ShadeHeaderBarState();
}

class _ShadeHeaderBarState extends State<ShadeHeaderBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.colorScheme.isLight;
    final states = <MaterialState>{
      if (widget.isActive != false) MaterialState.focused,
    };
    final defaultBackgroundColor = MaterialStateProperty.resolveWith((states) {
      if (!states.contains(MaterialState.focused)) {
        return theme.colorScheme.background;
      }
      return light ? ShadeUIColors.titleBarLight : ShadeUIColors.titleBarDark;
    });
    final backgroundColor = MaterialStateProperty.resolveAs(widget.backgroundColor, states) ?? defaultBackgroundColor.resolve(states);
    final foregroundColor = theme.colorScheme.onSurface;

    final titleTextStyle = (theme.appBarTheme.titleTextStyle ?? theme.textTheme.titleLarge!).copyWith(
      color: foregroundColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final defaultBorder = BorderSide(
      strokeAlign: -1,
      color: light ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.06),
    );
    final border = Border(bottom: defaultBorder);
    final shape = border + (const Border());

    const bSpacing = 0.0;
    const bPadding = EdgeInsets.only(left: BPPresets.small);

    Widget? backdropEffect(Widget? child) {
      if (child == null) return null;
      return AnimatedOpacity(
        opacity: widget.isActive == true ? 1 : 0.75,
        duration: const Duration(milliseconds: 100),
        child: child,
      );
    }

    Widget maybeHero({
      required Widget child,
    }) {
      if (widget.heroTag == null || context.findAncestorWidgetOfExactType<Hero>() != null) {
        return child;
      }
      return Hero(
        tag: widget.heroTag!,
        child: child,
      );
    }

    final closeButton = _ShadeWindowControl(
      foregroundColor: foregroundColor,
      icon: Icons.close_sharp,
      onTap: widget.onClose != null ? () => widget.onClose!(context) : null,
    );

    final gestureSettings = MediaQuery.maybeOf(context)?.gestureSettings;

    return TextFieldTapRegion(
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: {
          PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            PanGestureRecognizer.new,
            (instance) => instance
              //..onStart = widget.isDraggable == true ? (_) => widget.onDrag?.call(context) : null
              ..gestureSettings = gestureSettings
              ..onDown = ((_) => widget.onDragStart?.call(context))
              ..onEnd = ((_) => widget.onDragEnd?.call(context))
              ..onUpdate = ((p0) => widget.onDrag?.call(context, p0))
          ),
          _PassiveTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<_PassiveTapGestureRecognizer>(
              _PassiveTapGestureRecognizer.new,
              (instance) => instance
                ..onDoubleTap = (() => widget.isMaximizable == true
                    ? widget.onMaximize?.call(context)
                    : widget.isRestorable == true
                        ? widget.onRestore?.call(context)
                        : null)
                ..onSecondaryTap = widget.onShowMenu != null ? () => widget.onShowMenu!(context) : null
                ..gestureSettings = gestureSettings,
              ),
        },
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: backdropEffect(widget.leading),
          title: backdropEffect(widget.title),
          centerTitle: widget.centerTitle,
          titleSpacing: widget.titleSpacing ?? BPPresets.medium,
          toolbarHeight: (widget.leading == null && widget.actions == null) ? _defaultHeaderBarHeight : _populatedHeaderbarHeight,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          titleTextStyle: titleTextStyle,
          shape: shape,
          actions: [
            maybeHero(
              child: backdropEffect(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...?widget.actions,
                    if (widget.isMinimizable == true || widget.isRestorable == true || widget.isMaximizable == true || widget.isClosable == true)
                      Padding(
                        padding: bPadding,
                        child: Row(
                          children: [
                            if (widget.isMinimizable == true)
                              _ShadeWindowControl(
                                foregroundColor: foregroundColor,
                                icon: Icons.minimize_sharp,
                                onTap: widget.onMinimize != null ? () => widget.onMinimize!(context) : null,
                              ),
                            if (widget.isRestorable == true)
                              _ShadeWindowControl(
                                foregroundColor: foregroundColor,
                                icon: Icons.fullscreen_exit_sharp,
                                onTap: widget.onRestore != null ? () => widget.onRestore!(context) : null,
                              ),
                            if (widget.isMaximizable == true)
                              _ShadeWindowControl(
                                foregroundColor: foregroundColor,
                                icon: Icons.square_outlined,
                                onTap: widget.onMaximize != null ? () => widget.onMaximize!(context) : null,
                              ),
                            if (widget.isClosable == true)
                              widget.isMaximizable == true
                                  ? closeButton
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                      ),
                                      child: closeButton,
                                    ),
                          ].withSpacing(bSpacing),
                        ),
                      ),
                  ],
                ),
              )!,
            ),
          ],
        ),
      ),
    );
  }
}

extension _ListSpacing on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return expand((item) sync* {
      yield SizedBox(width: spacing);
      yield item;
    }).skip(1).toList();
  }
}

class _ShadeWindowControl extends StatefulWidget {
  final Color foregroundColor;
  final IconData icon;
  final Function()? onTap;

  const _ShadeWindowControl({
    required this.foregroundColor,
    required this.icon,
    required this.onTap,
  });

  @override
  _ShadeWindowControlState createState() => _ShadeWindowControlState();
}

class _ShadeWindowControlState extends State<_ShadeWindowControl> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: SizedBox(
        width: 30,
        height: 30,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: Colors.transparent,
              mouseCursor: SystemMouseCursors.alias,
              borderRadius: BorderRadius.circular(30),
              onTap: widget.onTap,
              child: Center(
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Theme.of(context).colorScheme.onInverseSurface),
                  child: Icon(
                    widget.icon,
                    size: 13,
                    color: widget.foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PassiveTapGestureRecognizer extends TapGestureRecognizer {
  _PassiveTapGestureRecognizer() {
    onTapUp = (_) {};
    onTapCancel = () {};
  }

  GestureDoubleTapCallback? onDoubleTap;

  PointerDownEvent? _firstTapDown;
  PointerUpEvent? _firstTapUp;

  @protected
  @override
  void handleTapUp({
    required PointerDownEvent down,
    required PointerUpEvent up,
  }) {
    super.handleTapUp(down: down, up: up);
    if (onDoubleTap != null && _firstTapDown != null && _firstTapUp != null && down.buttons == kPrimaryButton) {
      // the time from the first tap down to the second tap down
      final interval = down.timeStamp - _firstTapDown!.timeStamp;
      // the time from the first tap up to the second tap down
      final timeBetween = down.timeStamp - _firstTapUp!.timeStamp;
      // the distance between the first tap down and the first tap up
      final slop = (_firstTapDown!.position - _firstTapUp!.position).distance;
      // the distance between the first tap down and the second tap down
      final secondSlop = (_firstTapDown!.position - down.position).distance;
      if (interval < kDoubleTapTimeout && timeBetween >= kDoubleTapMinTime && slop <= kDoubleTapTouchSlop && secondSlop <= kDoubleTapSlop) {
        invokeCallback<void>('onDoubleTap', onDoubleTap!);
        _firstTapDown = null;
        _firstTapUp = null;
        return;
      }
    }
    _firstTapDown = down;
    _firstTapUp = up;
  }

  @protected
  @override
  void handleTapCancel({
    required PointerDownEvent down,
    PointerCancelEvent? cancel,
    required String reason,
  }) {
    super.handleTapCancel(down: down, cancel: cancel, reason: reason);
    _firstTapDown = null;
    _firstTapUp = null;
  }
}
