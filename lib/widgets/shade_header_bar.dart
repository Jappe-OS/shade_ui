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

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shade_ui/shade_ui.dart';
import 'package:yaru_window/yaru_window.dart';

const _kHeaderBarHeroTag = '<shadeui headerbar hero tag>';
const _kDefaultHeaderBarHeight = 35.0;
const _kPopulatedHeaderbarHeight = 45.0;

class ShadeHeaderBar extends StatefulWidget implements PreferredSizeWidget {
  /// The title of the headerbar.
  final String? title;

  /// A widget to display before the [title] widget.
  final Widget? leading;

  /// Widgets to display after the [title] widget.
  final List<Widget>? actions;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Spacing around the title.
  final double titleSpacing;

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
  Size get preferredSize => Size(0, (leading == null && actions == null) ? _kDefaultHeaderBarHeight : _kPopulatedHeaderbarHeight);

  const ShadeHeaderBar(
      {super.key,
      this.title,
      this.leading,
      this.actions,
      this.centerTitle = true,
      this.titleSpacing = BPPresets.medium,
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
      this.heroTag = _kHeaderBarHeroTag});

  @override
  _ShadeHeaderBarState createState() => _ShadeHeaderBarState();
}

class _ShadeHeaderBarState extends State<ShadeHeaderBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.colorScheme.isLight;
    final states = <WidgetState>{
      if (widget.isActive != false) WidgetState.focused,
    };
    final defaultBackgroundColor = WidgetStateProperty.resolveWith((states) {
      if (!states.contains(WidgetState.focused)) {
        return theme.colorScheme.surface;
      }
      return light ? ShadeUIColors.titleBarLight : ShadeUIColors.titleBarDark;
    });
    final backgroundColor = WidgetStateProperty.resolveAs(widget.backgroundColor, states) ?? defaultBackgroundColor.resolve(states);
    final foregroundColor = theme.colorScheme.onSurface;

    final titleTextStyle = (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
      color: foregroundColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final defaultBorder = BorderSide(
      strokeAlign: -1,
      color: light ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.06),
    );
    final border = Border(bottom: widget.backgroundColor == Colors.transparent ? BorderSide.none : defaultBorder);
    //final shape = border + (const Border());

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

    Widget maybeHero({required Widget child}) {
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

    Widget buildWindowControls() => Padding(
      padding: bPadding,
      child: SpacedRow(
        mainAxisSize: MainAxisSize.min,
        spacing: bSpacing,
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
        ],
      ),
    );

    return TextFieldTapRegion(
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: {
          PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            PanGestureRecognizer.new,
            (instance) => instance
              ..gestureSettings = gestureSettings
              ..onDown = ((_) => widget.onDragStart?.call(context))
              ..onEnd = ((_) => widget.onDragEnd?.call(context))
              ..onUpdate = ((p0) => widget.onDrag?.call(context, p0)),
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
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: BPPresets.small),
          height: widget.preferredSize.height,
          child: Row(
            mainAxisAlignment: widget.centerTitle == true ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.leading != null) ...[
                backdropEffect(widget.leading)!,
                const SizedBox(width: 8),
              ],
              if (widget.title != null)
                Expanded(
                  child: backdropEffect(
                    Text(
                      widget.title!,
                      style: titleTextStyle,
                    ),
                  )!,
                ),
              if (widget.actions != null || widget.isMinimizable == true || widget.isRestorable == true || widget.isMaximizable == true || widget.isClosable == true)
                maybeHero(
                  child: backdropEffect(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...?widget.actions,
                        buildWindowControls(),
                      ],
                    ),
                  )!,
                ),
            ],
          ),
        ),
      ),
    );
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

class ShadeWindowHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const ShadeWindowHeaderBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle,
    this.titleSpacing,
    this.backgroundColor,
    this.isActive,
    this.isClosable,
    this.isDraggable,
    this.isMaximizable,
    this.isMinimizable,
    this.isRestorable,
    this.onClose = YaruWindow.close,
    this.onDrag = YaruWindow.drag,
    this.onMaximize = YaruWindow.maximize,
    this.onMinimize = YaruWindow.minimize,
    this.onRestore = YaruWindow.restore,
    this.onShowMenu = YaruWindow.showMenu,
    this.heroTag = _kHeaderBarHeroTag,
  });

  /// The title of the headerbar.
  final String? title;

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

  /// Whether the title bar visualized as active.
  final bool? isActive;

  /// Whether the title bar shows a close button.
  final bool? isClosable;

  /// Whether the title bar can be dragged to move the window.
  final bool? isDraggable;

  /// Whether the title bar shows a maximize button.
  final bool? isMaximizable;

  /// Whether the title bar shows a minimize button.
  final bool? isMinimizable;

  /// Whether the title bar shows a restore button.
  final bool? isRestorable;

  /// Called when the close button is pressed.
  final FutureOr<void> Function(BuildContext)? onClose;

  /// Called when the title bar is dragged to move the window.
  final FutureOr<void> Function(BuildContext)? onDrag;

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
  Size get preferredSize => Size(0, (leading == null && actions == null) ? _kDefaultHeaderBarHeight : _kPopulatedHeaderbarHeight);

  static Future<void> ensureInitialized() {
    _windowStates.clear();
    return YaruWindow.ensureInitialized().then((window) => window.hideTitle());
  }

  static final _windowStates = <YaruWindowInstance, YaruWindowState>{};

  @override
  Widget build(BuildContext context) {
    final window = YaruWindow.of(context);
    return StreamBuilder<YaruWindowState>(
      stream: window.states(),
      initialData: _windowStates[window],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _windowStates[window] = snapshot.data!;
        }
        final state = snapshot.data;
        return ShadeHeaderBar(
          leading: leading,
          title: title ?? state?.title ?? '',
          actions: actions,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing ?? BPPresets.medium,
          backgroundColor: backgroundColor,
          isActive: isActive ?? state?.isActive,
          isClosable: isClosable ?? state?.isClosable,
          isDraggable: isDraggable ?? state?.isMovable,
          isMaximizable: isMaximizable ?? state?.isMaximizable,
          isMinimizable: isMinimizable ?? state?.isMinimizable,
          isRestorable: isRestorable ?? state?.isRestorable,
          onClose: onClose,
          onDrag: (bc, _) => onDrag?.call(bc),
          onMaximize: onMaximize,
          onMinimize: onMinimize,
          onRestore: onRestore,
          onShowMenu: onShowMenu,
          heroTag: heroTag,
        );
      },
    );
  }
}