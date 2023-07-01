import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class ShadeTheme extends ChangeNotifier {
  ShadeThemeAccent _accent = ShadeThemeAccent.blue;
  ShadeThemeAccent get accent => _accent;
  set accent(ShadeThemeAccent acc) {
    _accent = acc;
    notifyListeners();
  }

  static const _kDefaultBorderRad = 10.0;

  ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: accent.clr,
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      filledButtonTheme:
          FilledButtonThemeData(style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
    );
  }

  ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: accent.clr,
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      filledButtonTheme:
          FilledButtonThemeData(style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kDefaultBorderRad)))),
    );
  }
}

class ShadeThemeAccent {
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
