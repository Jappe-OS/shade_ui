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

/// A widget that appears like a normal [Text] widget, but can be edited just like a [TextField].
class ShadeEditableTextWidget extends StatefulWidget {
  final String initialText;
  final String hintText;
  final void Function(String)? onEditingComplete;
  final TextAlign textAlign;

  const ShadeEditableTextWidget({Key? key, required this.initialText, required this.hintText, this.onEditingComplete, this.textAlign = TextAlign.center}) : super(key: key);

  @override
  _ShadeEditableTextWidgetState createState() => _ShadeEditableTextWidgetState();
}

class _ShadeEditableTextWidgetState extends State<ShadeEditableTextWidget> {
  final TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocusChange);
    controller.text = widget.initialText;
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(_onFocusChange);
    focus.dispose();
    controller.dispose();
  }

  void _onFocusChange() {
    if (!focus.hasFocus) {
      widget.onEditingComplete?.call(controller.text);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (p0) => setState(() => isHovered = true),
      onExit: (p0) => setState(() => isHovered = false),
      child: TextField(
        controller: controller,
        focusNode: focus,
        onSubmitted: widget.onEditingComplete,
        textAlign: widget.textAlign,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: focus.hasFocus,
          enabledBorder: isHovered || focus.hasFocus ? Theme.of(context).inputDecorationTheme.enabledBorder : InputBorder.none,
          border: isHovered || focus.hasFocus ? Theme.of(context).inputDecorationTheme.border : InputBorder.none,
        ),
      ),
    );
  }
}
