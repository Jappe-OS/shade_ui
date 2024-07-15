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
import 'package:shade_ui/colors.dart';
import 'package:shade_ui/extensions.dart';
import 'package:shade_ui/text_theme.dart';

import 'constants.dart';
import 'shade_custom_theme_properties.dart';

/// Contains theme related properties.
/// From ShadeUI.
class ShadeTheme {
  static Color contrastColor(Color color) => ThemeData.estimateBrightnessForColor(
            color,
          ) ==
          Brightness.light
      ? Colors.black
      : Colors.white;

  static const _kkDividerColorDark = Color.fromARGB(255, 65, 65, 65);

  /// Light theme data to assign to [MaterialApp]s 'theme' param.
  static ThemeData light(ShadeCustomThemeProperties t) {
    final secondary = t.primary.scale(lightness: 0.2).cap(saturation: .9);
    final secondaryContainer = t.primary.scale(lightness: 0.85).cap(saturation: .5);
    final tertiary = t.primary.scale(lightness: 0.5).cap(saturation: .8);
    final tertiaryContainer = t.primary.scale(lightness: 0.75).cap(saturation: .75);

    Color surfaceBackgroundColor(Color base) {
      if (!t.accentifyColors) return base;

      return base.blend(t.primary, kAccentifyAmount);
    }

    final accentifiedBackground = surfaceBackgroundColor(ShadeUIColors.porcelain);
    final outline = accentifiedBackground.blend(Colors.black, 0.2);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: t.primary,
      error: ShadeUIColors.light.error,
      onError: Colors.white,
      brightness: Brightness.light,
      primary: t.primary,
      onPrimary: contrastColor(t.primary),
      primaryContainer: ShadeUIColors.porcelain,
      onPrimaryContainer: ShadeUIColors.jet,
      inversePrimary: ShadeUIColors.jet,
      secondary: secondary,
      onSecondary: contrastColor(secondary),
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: contrastColor(secondaryContainer),
      background: accentifiedBackground,
      onBackground: ShadeUIColors.jet,
      surface: Colors.white,
      onSurface: ShadeUIColors.jet,
      inverseSurface: surfaceBackgroundColor(ShadeUIColors.jet),
      onInverseSurface: surfaceBackgroundColor(ShadeUIColors.porcelain),
      surfaceTint: ShadeUIColors.warmGrey,
      surfaceVariant: ShadeUIColors.warmGrey,
      tertiary: tertiary,
      onTertiary: contrastColor(tertiary),
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: contrastColor(tertiaryContainer),
      onSurfaceVariant: ShadeUIColors.coolGrey,
      outline: outline,
      outlineVariant: Colors.black,
      scrim: Colors.black,
    );

    return _buildTheme(t, colorScheme);
  }

  /// Dark theme data to assign to [MaterialApp]s 'darkTheme' param.
  static ThemeData dark(ShadeCustomThemeProperties t) {
    final secondary = t.primary.scale(lightness: -0.3, saturation: -0.15);
    final secondaryContainer = t.primary.scale(lightness: -0.6, saturation: -0.75).capDown(lightness: .175);
    final tertiary = t.primary.scale(lightness: -0.5, saturation: -0.25);
    final tertiaryContainer = t.primary.scale(lightness: -0.5, saturation: -0.65).capDown(lightness: .2);

    Color surfaceBackgroundColor(Color base) {
      if (!t.accentifyColors) return base;

      return base.blend(t.primary, kAccentifyAmount);
    }

    final accentifiedBackground = surfaceBackgroundColor(ShadeUIColors.darkJet);
    final outline = accentifiedBackground.blend(Colors.white, 0.2);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: t.primary,
      error: ShadeUIColors.dark.error,
      onError: Colors.white,
      brightness: Brightness.dark,
      primary: t.primary,
      primaryContainer: ShadeUIColors.coolGrey,
      onPrimary: contrastColor(t.primary),
      onPrimaryContainer: ShadeUIColors.porcelain,
      inversePrimary: ShadeUIColors.porcelain,
      secondary: secondary,
      onSecondary: contrastColor(t.primary.scale(lightness: -0.25)),
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Colors.white,
      background: accentifiedBackground,
      onBackground: ShadeUIColors.porcelain,
      surface: ShadeUIColors.jet,
      onSurface: ShadeUIColors.porcelain,
      inverseSurface: surfaceBackgroundColor(ShadeUIColors.porcelain),
      onInverseSurface: surfaceBackgroundColor(ShadeUIColors.inkstone),
      surfaceTint: ShadeUIColors.coolGrey,
      surfaceVariant: const Color.fromARGB(255, 34, 34, 34),
      tertiary: tertiary,
      onTertiary: ShadeUIColors.porcelain,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: ShadeUIColors.porcelain,
      onSurfaceVariant: ShadeUIColors.warmGrey,
      outline: outline,
      outlineVariant: Colors.white,
      scrim: Colors.black,
    );

    return _buildTheme(t, colorScheme);
  }

  /// Builds the base theme using the input parameters.
  ///
  /// Only the input parameters can change between the dark and
  /// the light themes.
  static ThemeData _buildTheme(ShadeCustomThemeProperties t, ColorScheme colorScheme) {
    // Style Constants

    const buttonMouseCursor = SystemMouseCursors.alias;

    final commonButtonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(kButtonPadding),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRad))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.normal)),
      mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
    );

    final menuStyle = MenuStyle(
      surfaceTintColor: MaterialStateColor.resolveWith((states) => colorScheme.isDark ? colorScheme.surfaceVariant : colorScheme.surface),
      shape: MaterialStateProperty.resolveWith(
        (states) => RoundedRectangleBorder(
          side: BorderSide(
            color: colorScheme.onSurface.withOpacity(
              colorScheme.isLight ? 0.3 : 0.2,
            ),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: colorScheme.onSurface.withOpacity(
            colorScheme.isLight ? 0.3 : 0.2,
          ),
          width: 1,
        ),
      ),
      elevation: MaterialStateProperty.resolveWith((states) => 1),
      backgroundColor: MaterialStateProperty.resolveWith((states) => colorScheme.isDark ? colorScheme.surfaceVariant : colorScheme.surface),
    );

    final inputDecorationTheme = () {
      final fill = colorScheme.isLight
      ? const Color(0xFFededed)
      : const Color.fromARGB(255, 40, 40, 40);

      return InputDecorationTheme(
        contentPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 9, top: 10),
        constraints: const BoxConstraints(
          minHeight: kButtonHeight,
          maxHeight: kButtonHeight,
        ),
        filled: true,
        fillColor: fill,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
        iconColor: colorScheme.onSurface,
        helperStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        suffixStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ).copyWith(
          color: colorScheme.onSurface.scale(lightness: -0.2),
        ),
        prefixStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ).copyWith(
          color: colorScheme.onSurface.scale(lightness: -0.2),
        ),
      );
    }();

    // Style Getters

    Color getCheckFillColor(Set<MaterialState> states, ColorScheme colorScheme) {
      if (!states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurface.withOpacity(0.75);
      }
      if (states.contains(MaterialState.selected)) {
        return colorScheme.onSurface.withOpacity(0.2);
      }
      return colorScheme.onSurface.withOpacity(0.2);
    }

    Color getCheckColor(Set<MaterialState> states, ColorScheme colorScheme) {
      if (!states.contains(MaterialState.disabled)) {
        return ThemeData.estimateBrightnessForColor(colorScheme.primary) == Brightness.light ? Colors.black : Colors.white;
      }
      return ShadeUIColors.warmGrey;
    }

    Color getSwitchThumbColor(Set<MaterialState> states, ColorScheme colorScheme) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onSurface.withOpacity(0.5);
        }
        return colorScheme.onSurface.withOpacity(0.5);
      } else {
        return colorScheme.onPrimary;
      }
    }

    Color getSwitchTrackColor(Set<MaterialState> states, ColorScheme colorScheme) {
      final uncheckedColor = colorScheme.onSurface.withOpacity(.25);
      final disabledUncheckedColor = colorScheme.onSurface.withOpacity(.15);
      final disabledCheckedColor = colorScheme.onSurface.withOpacity(.18);

      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return disabledCheckedColor;
        }
        return disabledUncheckedColor;
      } else {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primary;
        } else {
          return uncheckedColor;
        }
      }
    }

    final textTheme = createTextTheme(colorScheme.onSurface);

    return ThemeData.from(
      useMaterial3: true,
      colorScheme: colorScheme,
    ).copyWith(
      brightness: colorScheme.brightness,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      primaryIconTheme: IconThemeData(color: colorScheme.onSurface),
      primaryColor: colorScheme.primary,
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.outline,
      dialogBackgroundColor: colorScheme.background,
      indicatorColor: colorScheme.primary,
      applyElevationOverlayColor: colorScheme.isDark,
      primaryColorDark: colorScheme.isDark ? colorScheme.primary : null,
      textSelectionTheme: TextSelectionThemeData(cursorColor: colorScheme.onSurface, selectionColor: colorScheme.primary.withOpacity(0.40)),

      // Buttons

      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRad),
        ),
        height: kButtonHeight,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondaryContainer,
          elevation: 0,
          shadowColor: Colors.transparent,
        ).merge(commonButtonStyle),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
          backgroundColor: colorScheme.onSurface.withOpacity(0.1),
          surfaceTintColor: colorScheme.onSurface.withOpacity(0.1),
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          shadowColor: Colors.transparent,
        ).merge(commonButtonStyle),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
        ).merge(commonButtonStyle),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: colorScheme.primary,
          foregroundColor: colorScheme.primary,
        ).merge(commonButtonStyle),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          highlightColor: colorScheme.onSurface.withOpacity(0.05),
          surfaceTintColor: colorScheme.background,
          disabledMouseCursor: buttonMouseCursor,
          enabledMouseCursor: buttonMouseCursor,
        ),
      ),

      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.center,
          textStyle: MaterialStatePropertyAll(textTheme.bodyMedium),
          mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(kButtonPadding),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(kDefaultBorderRad))),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary.withOpacity(0.4);
            }

            return Colors.transparent;
          }),
          mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
        ),
      ),

      // Text Input

      inputDecorationTheme: inputDecorationTheme,

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputDecorationTheme,
        menuStyle: menuStyle,
      ),

      // Slider

      sliderTheme: SliderThemeData(
        thumbColor: Colors.white,
        trackHeight: 6,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: kButtonHeight / 2),
        overlayColor: colorScheme.primary.withOpacity(colorScheme.isLight ? 0.4 : 0.7),
        thumbShape: const RoundSliderThumbShape(elevation: 3.0),
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
        mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
      ),

      // Check

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCheckRadius),
        ),
        fillColor: MaterialStateProperty.resolveWith(
          (states) => getCheckFillColor(states, colorScheme),
        ),
        checkColor: MaterialStateProperty.resolveWith(
          (states) => getCheckColor(states, colorScheme),
        ),
        mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => getCheckFillColor(states, colorScheme),
        ),
        mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
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
        selectedColor: colorScheme.onSurface,
        fillColor: colorScheme.outline,
        hoverColor: colorScheme.onSurface.withOpacity(.05),
      ),
      switchTheme: SwitchThemeData(
        splashRadius: kButtonHeight / 2,
        trackOutlineColor: MaterialStateColor.resolveWith(
          (states) => Colors.transparent,
        ),
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => getSwitchThumbColor(states, colorScheme),
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => getSwitchTrackColor(states, colorScheme),
        ),
        mouseCursor: const MaterialStatePropertyAll(buttonMouseCursor),
      ),

      // Other

      appBarTheme: AppBarTheme(
        shape: Border(
          bottom: BorderSide(
            strokeAlign: -1,
            color: colorScheme.onSurface.withOpacity(
              colorScheme.isLight ? 0.2 : 0.07,
            ),
          ),
        ),
        scrolledUnderElevation: kAppBarElevation,
        surfaceTintColor: colorScheme.surface,
        elevation: kAppBarElevation,
        systemOverlayStyle: colorScheme.isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: createTextTheme(colorScheme.onSurface).titleLarge!.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.normal,
            ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: kCompactIconSize,
        ),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        toolbarHeight: kCompactAppBarHeight,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: contrastColor(colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide.none,
        ),
        elevation: 3.0,
        focusElevation: 3.0,
        hoverElevation: 3.0,
        disabledElevation: 3.0,
        highlightElevation: 3.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.8),
      ),
      menuTheme: MenuThemeData(style: menuStyle),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.isDark ? colorScheme.surfaceVariant : colorScheme.surface,
        surfaceTintColor: colorScheme.isDark ? colorScheme.surfaceVariant : colorScheme.surface,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(
              colorScheme.isLight ? 0.3 : 0.2,
            ),
            width: 1,
          ),
        ),
      ),
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 500),
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: colorScheme.surface),
      navigationBarTheme: NavigationBarThemeData(
        height: kCompactNavigationBarHeight,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        indicatorColor: colorScheme.onSurface.withOpacity(0.1),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? IconThemeData(color: colorScheme.onSurface)
              : IconThemeData(color: colorScheme.onSurface.withOpacity(0.8)),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.onSurface.withOpacity(0.1),
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: kCompactIconSize,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withOpacity(0.8),
          size: kCompactIconSize,
        ),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outline, space: 1.0, thickness: 0.0),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.primary,
        textColor: contrastColor(colorScheme.primary),
      ),
      scrollbarTheme: const ScrollbarThemeData(
        mainAxisMargin: 3.0,
        crossAxisMargin: 3.0,
      ),
      drawerTheme: DrawerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(kWindowRadius),
            bottomEnd: Radius.circular(kWindowRadius),
          ),
          side: BorderSide(
            color: colorScheme.isLight ? Colors.transparent : _kkDividerColorDark,
          ),
        ),
        backgroundColor: colorScheme.background,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurface.withOpacity(0.8),
      ),
      snackBarTheme: SnackBarThemeData(
        width: kSnackBarWidth,
        backgroundColor: const Color.fromARGB(255, 20, 20, 20).withOpacity(0.95),
        closeIconColor: Colors.white,
        actionTextColor: Colors.white,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionBackgroundColor: Colors.transparent,
        disabledActionTextColor: Colors.white.withOpacity(0.7),
        disabledActionBackgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonHeight),
        ),
      ),
      chipTheme: ChipThemeData(selectedColor: colorScheme.primary.withOpacity(.4)),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: colorScheme.primary.withOpacity(0.3),
        linearTrackColor: colorScheme.primary.withOpacity(0.3),
        color: colorScheme.primary,
      ),
      menuBarTheme: const MenuBarThemeData(
        style: MenuStyle(
          minimumSize: MaterialStatePropertyAll(Size(0, kButtonHeight)),
          maximumSize: MaterialStatePropertyAll(Size(double.infinity, kButtonHeight)),
          shadowColor: MaterialStatePropertyAll(Colors.black),
          elevation: MaterialStatePropertyAll(2),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.isLight ? colorScheme.onSurface : Colors.white.withOpacity(0.8),
        indicatorColor: colorScheme.primary,
        dividerColor: colorScheme.outline,
        overlayColor: MaterialStateColor.resolveWith(
          (states) => colorScheme.onSurface.withOpacity(0.05),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark ? ShadeUIColors.darkJet : ShadeUIColors.porcelain,
        surfaceTintColor: colorScheme.brightness == Brightness.dark ? ShadeUIColors.darkJet : ShadeUIColors.porcelain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kWindowRadius),
          side: colorScheme.isDark
              ? BorderSide(
                  color: Colors.white.withOpacity(0.2),
                )
              : BorderSide.none,
        ),
      ),
      textTheme: textTheme,
    );
  }
}

//class ShadeThemeWidgets extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    
//  }
//}