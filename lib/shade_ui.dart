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

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shade_ui/extensions.dart';
import 'package:shade_ui/text_theme.dart';

import 'colors.dart';

/// Creates a ShadeApp (MaterialApp).
///
/// At least one of [home], [routes], [onGenerateRoute], or [builder] must be non-null.
/// If only [routes] is given, it must include an entry for the [Navigator.defaultRouteName] (/),
/// since that is the route used when the application is launched with an intent that
/// specifies an otherwise unsupported route.
///
/// The [MaterialApp] class creates an instance of [WidgetsApp].
///
/// The boolean arguments, [routes], and [navigatorObservers], must not be null.
///
/// Theme cannot currently be modified via this class; see [Provider] and [ShadeTheme] to
/// change/listen to theme properties in runtime.
class ShadeApp extends StatelessWidget {
  final ShadeCustomThemeProperties? customThemeProperties;
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final Widget Function(BuildContext, Widget?)? builder;
  final String title;
  final String Function(BuildContext)? onGenerateTitle;
  final Color? color;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? Function(List<Locale>?, Iterable<Locale>)? localeListResolutionCallback;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;

  const ShadeApp(
      {Key? key,
      this.customThemeProperties,
      this.navigatorKey,
      this.scaffoldMessengerKey,
      this.home,
      this.routes = const <String, WidgetBuilder>{},
      this.initialRoute,
      this.onGenerateRoute,
      this.onGenerateInitialRoutes,
      this.onUnknownRoute,
      this.navigatorObservers = const <NavigatorObserver>[],
      this.builder,
      this.title = '',
      this.onGenerateTitle,
      this.color,
      this.themeAnimationDuration = kThemeAnimationDuration,
      this.themeAnimationCurve = Curves.linear,
      this.locale,
      this.localizationsDelegates,
      this.localeListResolutionCallback,
      this.localeResolutionCallback,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.debugShowMaterialGrid = false,
      this.showPerformanceOverlay = false,
      this.checkerboardRasterCacheImages = false,
      this.checkerboardOffscreenLayers = false,
      this.showSemanticsDebugger = false,
      this.debugShowCheckedModeBanner = true,
      this.shortcuts,
      this.actions,
      this.restorationScopeId,
      this.scrollBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => customThemeProperties ?? ShadeCustomThemeProperties.setDefault(),
        builder: (context, child) {
          var themeProvider = Provider.of<ShadeCustomThemeProperties>(context);
          return MaterialApp(
            theme: ShadeTheme.light(themeProvider),
            darkTheme: ShadeTheme.dark(themeProvider),
            home: home,
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: scaffoldMessengerKey,
            routes: routes,
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            onUnknownRoute: onUnknownRoute,
            navigatorObservers: navigatorObservers,
            builder: builder,
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
            themeMode: themeProvider.themeMode,
            themeAnimationDuration: themeAnimationDuration,
            themeAnimationCurve: themeAnimationCurve,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            debugShowMaterialGrid: debugShowMaterialGrid,
            showPerformanceOverlay: showPerformanceOverlay,
            checkerboardRasterCacheImages: checkerboardRasterCacheImages,
            checkerboardOffscreenLayers: checkerboardOffscreenLayers,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions,
            restorationScopeId: restorationScopeId,
            scrollBehavior: scrollBehavior,
          );
        });
  }
}

/// Manages customised theme properties that modify the look of the UI.
///
/// * **Use this class in UI:**
///
/// The following example shows a way to listen to theme changes
/// (mostly used in custom widgets), and a way to set theme
/// properties runtime and notify all listeners.
///
/// ```dart
/// var themeProvider = Provider.of<ShadeCustomThemeProperties>(context);
///
/// //...
///
/// // To listen
/// /*...*/themeProvider.accent;
/// // To set
/// /*...*/themeProvider.accent = ShadeThemeAccent.blue;
/// ```
class ShadeCustomThemeProperties extends ChangeNotifier {
  ThemeMode? _themeMode;
  ThemeMode get themeMode => _themeMode ?? ThemeMode.system;
  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  Color? _primary;
  Color get primary => _primary ?? ShadeThemePrimary.blue;
  set accent(Color primary) {
    _primary = primary;
    notifyListeners();
  }

  bool? _accentifyColors;
  bool get accentifyColors => _accentifyColors ?? false;
  set accentifyColors(bool accentify) {
    _accentifyColors = accentify;
    notifyListeners();
  }

  ShadeCustomThemeProperties(this._themeMode, this._primary, this._accentifyColors);

  factory ShadeCustomThemeProperties.setDefault() => ShadeCustomThemeProperties(null, null, null);
}

/// Contains theme related properties.'
/// From ShadeUI.
class ShadeTheme {
  static Color contrastColor(Color color) => ThemeData.estimateBrightnessForColor(
            color,
          ) ==
          Brightness.light
      ? Colors.black
      : Colors.white;

  static const _kAccentifyAmount = 0.185;
  static const _kDefaultBorderRad = 7.0;
  static const _kButtonHeight = 35.0;
  static const _kButtonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15.5);
  static const _kCheckRadius = 3.0;
  static const _kCompactIconSize = 20.0;
  static const _kAppBarElevation = 0.0;
  static const _kCompactAppBarHeight = 46.0;
  static const _kCompactNavigationBarHeight = 64.0;
  static const _kWindowRadius = 8.0;
  static const _kSnackBarWidth = 350.0;

  static const _kkDividerColorDark = Color.fromARGB(255, 65, 65, 65);

  /// Light theme data to assign to [MaterialApp]s 'theme' param.
  static ThemeData light(ShadeCustomThemeProperties t) {
    final secondary = t.primary.scale(lightness: 0.2).cap(saturation: .9);
    final secondaryContainer = t.primary.scale(lightness: 0.85).cap(saturation: .5);
    final tertiary = t.primary.scale(lightness: 0.5).cap(saturation: .8);
    final tertiaryContainer = t.primary.scale(lightness: 0.75).cap(saturation: .75);

    Color surfaceBackgroundColor(Color base) {
      if (!t.accentifyColors) return base;

      var amount = _kAccentifyAmount;

      int blendedRed = (base.red + (t.primary.red - base.red) * amount).round();
      int blendedGreen = (base.green + (t.primary.green - base.green) * amount).round();
      int blendedBlue = (base.blue + (t.primary.blue - base.blue) * amount).round();
      int blendedAlpha = (base.alpha + (t.primary.alpha - base.alpha) * amount).round();

      return Color.fromARGB(blendedAlpha, blendedRed, blendedGreen, blendedBlue);
    }

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
      background: surfaceBackgroundColor(ShadeUIColors.porcelain),
      onBackground: ShadeUIColors.jet,
      surface: Colors.white,
      onSurface: ShadeUIColors.jet,
      inverseSurface: ShadeUIColors.jet,
      onInverseSurface: ShadeUIColors.porcelain,
      surfaceTint: ShadeUIColors.warmGrey,
      surfaceVariant: ShadeUIColors.warmGrey,
      tertiary: tertiary,
      onTertiary: contrastColor(tertiary),
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: contrastColor(tertiaryContainer),
      onSurfaceVariant: ShadeUIColors.coolGrey,
      outline: const Color.fromARGB(255, 221, 221, 221),
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

      var amount = _kAccentifyAmount;

      int blendedRed = (base.red + (t.primary.red - base.red) * amount).round();
      int blendedGreen = (base.green + (t.primary.green - base.green) * amount).round();
      int blendedBlue = (base.blue + (t.primary.blue - base.blue) * amount).round();
      int blendedAlpha = (base.alpha + (t.primary.alpha - base.alpha) * amount).round();

      return Color.fromARGB(blendedAlpha, blendedRed, blendedGreen, blendedBlue);
    }

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
      background: surfaceBackgroundColor(ShadeUIColors.darkJet),
      onBackground: ShadeUIColors.porcelain,
      surface: ShadeUIColors.jet,
      onSurface: ShadeUIColors.porcelain,
      inverseSurface: ShadeUIColors.porcelain,
      onInverseSurface: ShadeUIColors.inkstone,
      surfaceTint: ShadeUIColors.coolGrey,
      surfaceVariant: const Color.fromARGB(255, 34, 34, 34),
      tertiary: tertiary,
      onTertiary: ShadeUIColors.porcelain,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: ShadeUIColors.porcelain,
      onSurfaceVariant: ShadeUIColors.warmGrey,
      outline: const Color.fromARGB(255, 68, 68, 68),
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
    ButtonStyle commonButtonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(_kButtonPadding),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad))),
      textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.normal)),
    );

    MenuStyle menuStyle = MenuStyle(
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
          borderRadius: BorderRadius.circular(_kDefaultBorderRad),
        ),
        height: 35,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
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
        ),
      ),

      menuButtonTheme: MenuButtonThemeData(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.center,
          textStyle: MaterialStatePropertyAll(textTheme.bodyMedium),
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(_kButtonPadding),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad))),
        ),
      ),

      // Text Input

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: (56 - 35) / 2 - 1),
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(_kDefaultBorderRad),
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
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        menuStyle: menuStyle,
      ),

      // Slider

      sliderTheme: SliderThemeData(
        thumbColor: Colors.white,
        trackHeight: 6,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: _kButtonHeight / 2),
        overlayColor: colorScheme.primary.withOpacity(colorScheme.isLight ? 0.4 : 0.7),
        thumbShape: const RoundSliderThumbShape(elevation: 3.0),
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
      ),

      // Check

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_kCheckRadius),
        ),
        fillColor: MaterialStateProperty.resolveWith(
          (states) => getCheckFillColor(states, colorScheme),
        ),
        checkColor: MaterialStateProperty.resolveWith(
          (states) => getCheckColor(states, colorScheme),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => getCheckFillColor(states, colorScheme),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        constraints: const BoxConstraints(
          minHeight: _kButtonHeight,
          minWidth: 50,
          maxWidth: double.infinity,
          maxHeight: _kButtonHeight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(_kDefaultBorderRad)),
        borderColor: colorScheme.outline,
        selectedColor: colorScheme.onSurface,
        fillColor: colorScheme.outline,
        hoverColor: colorScheme.onSurface.withOpacity(.05),
      ),
      switchTheme: SwitchThemeData(
        splashRadius: _kButtonHeight / 2,
        trackOutlineColor: MaterialStateColor.resolveWith(
          (states) => Colors.transparent,
        ),
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => getSwitchThumbColor(states, colorScheme),
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => getSwitchTrackColor(states, colorScheme),
        ),
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
        scrolledUnderElevation: _kAppBarElevation,
        surfaceTintColor: colorScheme.surface,
        elevation: _kAppBarElevation,
        systemOverlayStyle: colorScheme.isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: createTextTheme(colorScheme.onSurface).titleLarge!.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.normal,
            ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: _kCompactIconSize,
        ),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        toolbarHeight: _kCompactAppBarHeight,
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
        height: _kCompactNavigationBarHeight,
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
          size: _kCompactIconSize,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withOpacity(0.8),
          size: _kCompactIconSize,
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
            topEnd: Radius.circular(_kWindowRadius),
            bottomEnd: Radius.circular(_kWindowRadius),
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
        width: _kSnackBarWidth,
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
          borderRadius: BorderRadius.circular(_kButtonHeight),
        ),
      ),
      chipTheme: ChipThemeData(selectedColor: colorScheme.primary.withOpacity(.4)),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: colorScheme.primary.withOpacity(0.3),
        linearTrackColor: colorScheme.primary.withOpacity(0.3),
        color: colorScheme.primary,
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
          borderRadius: BorderRadius.circular(_kWindowRadius),
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

/// Contains accent colors used in the UI.
class ShadeThemePrimary {
  static const Color blue = Colors.blueAccent;
  static const Color red = Colors.redAccent;
  static const Color yellow = Colors.yellowAccent;
  static const Color green = Colors.greenAccent;
  static const Color orange = Colors.orangeAccent;
  static const Color pink = Colors.pinkAccent;
  static const Color indigo = Colors.indigoAccent;
}
