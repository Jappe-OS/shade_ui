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
import 'package:shade_ui/utils.dart';

/// A textfield which can contain editable text, by ShadeUI.
class ShadeTextfield extends StatefulWidget {
  /// Text shown when the textfield is empty.
  final String? hintText;

  /// Indicates what the textbox is used for.
  final String? labelText;

  /// Whether to automatically focus the textfield.
  final bool autoFocus;

  /// Whther the content is modifiable.
  final bool readOnly;

  /// Character used for obscuring text if [obscureText] is true.
  final String obscuringCharacter;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// This [Function] is called when the textfield is submitted.
  final Function(String)? onSubmitted;

  /// This [Function] is called when the editing of the content is complete.
  final Function()? onEditingComplete;

  /// This [Function] is called when the content of the textfield has changed.
  final Function(String)? onChanged;

  const ShadeTextfield(
      {Key? key,
      this.hintText,
      this.labelText,
      this.autoFocus = false,
      this.readOnly = false,
      this.obscuringCharacter = '•',
      this.obscureText = false,
      this.autocorrect = true,
      this.onSubmitted,
      this.onEditingComplete,
      this.onChanged})
      : super(key: key);

  @override
  _ShadeTextfieldState createState() => _ShadeTextfieldState();
}

/// The [State] class for [ShadeTextfield].
class _ShadeTextfieldState extends State<ShadeTextfield> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SHUI_SINGLE_LINE_ELEMENT_HEIGHT,
      child: Focus(
        onFocusChange: (value) => setState(() => _isFocused = value),
        child:TextField(
        autofocus: widget.autoFocus,
        readOnly: widget.readOnly,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        onSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        onChanged: widget.onChanged,
        cursorColor: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().accentColor,
        decoration: InputDecoration(
          fillColor: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().transparentFillColor,
          filled: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.only(left: 7.5, right: 7.5, top: 11, bottom: 11),
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.7, color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().borderColor),
              borderRadius: BorderRadius.circular(SHUI_DEFAULT_BORDER_RADIUS)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.7, color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().accentColor),
              borderRadius: BorderRadius.circular(SHUI_DEFAULT_BORDER_RADIUS)),
          hintStyle: TextStyle(
            color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().secondaryTextColor,
          ),
          labelStyle: TextStyle(
            color: _isFocused
                ? context.watch<ShadeThemeProvider>().getCurrentThemeProperties().accentColor
                : context.watch<ShadeThemeProvider>().getCurrentThemeProperties().normalTextColor,
          ),
        ),
        style: TextStyle(
          color: context.watch<ShadeThemeProvider>().getCurrentThemeProperties().normalTextColor,
        ),
      ),),
    );
  }
}
