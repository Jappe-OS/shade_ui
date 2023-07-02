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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final ThemeMode? themeMode;
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
      this.themeMode = ThemeMode.system,
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
        create: (_) => ShadeTheme(),
        builder: (context, child) {
          var themeProvider = Provider.of<ShadeTheme>(context);
          return MaterialApp(
            theme: themeProvider.light(),
            darkTheme: themeProvider.dark(),
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
            themeMode: themeMode,
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

/// Contains theme related properties.'
/// From ShadeUI.
///
/// * **Use this class in UI:**
/// 
/// The following example shows a way to listen to theme changes
/// (mostly used in custom widgets), and a way to set theme
/// properties runtime and notify all listeners.
/// 
/// ```dart
/// var themeProvider = Provider.of<ShadeTheme>(context);
///
/// //...
/// 
/// // To listen
/// /*...*/themeProvider.accent;
/// // To set
/// /*...*/themeProvider.accent = ShadeThemeAccent.blue;
/// ```
class ShadeTheme extends ChangeNotifier {
  ShadeThemeAccent _accent = ShadeThemeAccent.blue;
  /// Get the current accent/primary color of the UI.
  ShadeThemeAccent get accent => _accent;
  /// Set the current accent/primary color of the UI.
  set accent(ShadeThemeAccent acc) {
    _accent = acc;
    notifyListeners();
  }

  static const _kDefaultBorderRad = 10.0;

  /// Light theme data to assign to [MaterialApp]s 'theme' param.
  ThemeData light() {
    return _buildTheme(Brightness.light);
  }

  /// Dark theme data to assign to [MaterialApp]s 'darkTheme' param.
  ThemeData dark() {
    return _buildTheme(Brightness.dark);
  }

  /// Builds the base theme using the input parameters.
  /// 
  /// Only the input parameters can change between the dark and
  /// the light themes.
  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: accent.clr,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      inputDecorationTheme:
          const InputDecorationTheme(contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: (56 - 35) / 2), filled: true, isDense: true),
    );
  }
}

/// Contains accent colors used in the UI.
class ShadeThemeAccent {
  /// The [Color] of this [ShadeThemeAccent] instance.
  final Color clr;
  const ShadeThemeAccent(this.clr);

  static const ShadeThemeAccent blue = ShadeThemeAccent(Colors.blueAccent);
  static const ShadeThemeAccent red = ShadeThemeAccent(Colors.redAccent);
  static const ShadeThemeAccent yellow = ShadeThemeAccent(Colors.yellowAccent);
  static const ShadeThemeAccent green = ShadeThemeAccent(Colors.greenAccent);
  static const ShadeThemeAccent orange = ShadeThemeAccent(Colors.orangeAccent);
  static const ShadeThemeAccent pink = ShadeThemeAccent(Colors.pinkAccent);
  static const ShadeThemeAccent indigo = ShadeThemeAccent(Colors.indigoAccent);
}
