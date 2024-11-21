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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shade_ui/shade_ui.dart';
import 'package:shade_ui/text_theme.dart';

/// Contains theme related properties.
/// From ShadeUI.
class ShadeTheme {
  static Color contrastColor(Color color) => ThemeData.estimateBrightnessForColor(
            color,
          ) ==
          Brightness.light
      ? Colors.black
      : Colors.white;

  /// Light theme data to assign to [MaterialApp]s 'theme' param.
  static ThemeData light(ShadeCustomThemeProperties t) {
    var colorScheme = ColorScheme.fromSeed(seedColor: t.primary, brightness: Brightness.light);
    colorScheme = colorScheme.copyWith(
      outline: colorScheme.inverseSurface.blend(colorScheme.surface, 0.75),
      surfaceContainer: colorScheme.surfaceContainer.scale(lightness: -0.03),
      surfaceContainerLow: colorScheme.surfaceContainerLow.scale(lightness: -0.03),
    );

    return _buildTheme(t, colorScheme);
  }

  /// Dark theme data to assign to [MaterialApp]s 'darkTheme' param.
  static ThemeData dark(ShadeCustomThemeProperties t) {
    var colorScheme = ColorScheme.fromSeed(seedColor: t.primary, brightness: Brightness.dark);
    colorScheme = colorScheme.copyWith(
      outline: colorScheme.inverseSurface.blend(colorScheme.surface, 0.75),
      surfaceContainer: colorScheme.surfaceContainer.scale(lightness: 0.03),
      surfaceContainerLow: colorScheme.surfaceContainerLow.scale(lightness: 0.03),
    );

    return _buildTheme(t, colorScheme);
  }

  /// Builds the base theme using the input parameters.
  ///
  /// Only the input parameters can change between the dark and
  /// the light themes.
  static ThemeData _buildTheme(ShadeCustomThemeProperties t, ColorScheme colorScheme) {
    // Style Constants

    const buttonMouseCursor = SystemMouseCursors.basic;

    final commonButtonStyle = ButtonStyle(
      padding: const WidgetStatePropertyAll(kButtonPadding),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRad))),
      mouseCursor: const WidgetStatePropertyAll(buttonMouseCursor),
    );

    final menuStyle = MenuStyle(
      shape: WidgetStateProperty.resolveWith(
        (states) => RoundedRectangleBorder(
          side: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: colorScheme.outline,
          width: 1,
        ),
      ),
      elevation: const WidgetStatePropertyAll(1),
      backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
    );

    final inputDecorationTheme = () {
      return InputDecorationTheme(
        contentPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
        constraints: const BoxConstraints(
          minHeight: kButtonHeight,
          maxHeight: kButtonHeight,
        ),
        filled: true,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
      );
    }();

    final textTheme = createTextTheme(colorScheme.onSurface);

    return ThemeData.from(
      useMaterial3: true,
      colorScheme: colorScheme,
    ).copyWith(
      brightness: colorScheme.brightness,
      dividerColor: colorScheme.outline,
      indicatorColor: colorScheme.primary,

      // Buttons

      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
        height: kButtonHeight,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          enabledMouseCursor: buttonMouseCursor,
          disabledMouseCursor: buttonMouseCursor,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ).merge(commonButtonStyle),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          enabledMouseCursor: buttonMouseCursor,
          disabledMouseCursor: buttonMouseCursor,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.primary,
        ).merge(commonButtonStyle),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: commonButtonStyle,
      ),

      textButtonTheme: TextButtonThemeData(
        style: commonButtonStyle,
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          disabledMouseCursor: buttonMouseCursor,
          enabledMouseCursor: buttonMouseCursor,
          minimumSize: const Size(kButtonHeight, kButtonHeight),
          maximumSize: const Size(double.infinity, kButtonHeight),
        ),
      ),

      menuButtonTheme: const MenuButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.standard,
          alignment: Alignment.center,
          mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
          minimumSize: WidgetStatePropertyAll(Size(50, kButtonHeight)),
          maximumSize: WidgetStatePropertyAll(Size(double.infinity, kButtonHeight)),
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(kButtonPadding),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRad))),
          mouseCursor: const WidgetStatePropertyAll(buttonMouseCursor),
        ),
      ),

      // Text Input
    
      inputDecorationTheme: inputDecorationTheme,

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputDecorationTheme,
        menuStyle: menuStyle,
      ),

      // Slider

      sliderTheme: const SliderThemeData(
        trackHeight: 10,
        overlayShape: RoundSliderOverlayShape(overlayRadius: kButtonHeight / 2),
        mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
      ),

      // Check

      checkboxTheme: const CheckboxThemeData(
        splashRadius: kButtonHeight / 2,
        mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
      ),

      radioTheme: const RadioThemeData(
        mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
      ),

      toggleButtonsTheme: ToggleButtonsThemeData(
        constraints: const BoxConstraints(
          minHeight: kButtonHeight,
          minWidth: 50,
          maxWidth: double.infinity,
          maxHeight: kButtonHeight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(kDefaultBorderRad)),
        borderColor: colorScheme.outline,
      ),

      switchTheme: const SwitchThemeData(
        splashRadius: kButtonHeight / 2,
        mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
      ),

      // Other

      appBarTheme: AppBarTheme(
        shape: Border(
          bottom: BorderSide(
            strokeAlign: -1,
            color: colorScheme.surfaceContainerHighest,
          ),
        ),
        scrolledUnderElevation: kAppBarElevation,
        surfaceTintColor: colorScheme.surface,
        elevation: kAppBarElevation,
        systemOverlayStyle: colorScheme.isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: kCompactIconSize,
        ),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        toolbarHeight: kCompactAppBarHeight,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        mouseCursor: const WidgetStatePropertyAll(buttonMouseCursor),
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRad * 2),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
        elevation: 1.0,
        focusElevation: 3.0,
        hoverElevation: 3.0,
        disabledElevation: 1.0,
        highlightElevation: 3.0,
      ),
      menuTheme: MenuThemeData(style: menuStyle),
      popupMenuTheme: PopupMenuThemeData(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 500),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: kCompactIconSize,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withOpacity(0.8),
          size: kCompactIconSize,
        ),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline/*, space: 1.0, thickness: 0.0*/),
      scrollbarTheme: const ScrollbarThemeData(
        mainAxisMargin: 3.0,
        crossAxisMargin: 3.0,
      ),
      snackBarTheme: const SnackBarThemeData(
        width: kSnackBarWidth,
        behavior: SnackBarBehavior.floating,
        elevation: 1,
      ),
      menuBarTheme: const MenuBarThemeData(
        style: MenuStyle(
          shape: WidgetStatePropertyAll(LinearBorder()),
          minimumSize: WidgetStatePropertyAll(Size(0, kButtonHeight)),
          maximumSize: WidgetStatePropertyAll(Size(double.infinity, kButtonHeight)),
          shadowColor: WidgetStatePropertyAll(Colors.black),
          elevation: WidgetStatePropertyAll(2),
        ),
      ),
      tabBarTheme: TabBarTheme(
        mouseCursor: const WidgetStatePropertyAll(buttonMouseCursor),
        dividerColor: colorScheme.outline,
      ),
      dialogTheme: DialogTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kWindowRadius),
          side: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        mouseCursor: WidgetStatePropertyAll(buttonMouseCursor),
        contentPadding: EdgeInsets.symmetric(horizontal: BPPresets.small, vertical: 0),
      ),
      textTheme: textTheme,
    );
  }
}