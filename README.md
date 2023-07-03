# Shade UI
A UI system used by JappeOS apps. Works alongside with material widgets.

## Migrate from 1.0
Here's a short tutorial on migrating from the old 1.0 version to this new version (2.x).

1. Replace all Shade- widgets with material widgets. A button would have the `text` param, but on a material button, it would not be a named parameter, so remove `text:`, and you're done! Also, you may need to replace `onPress` with `onPressed` on several widgets. After that, there should not be a lot to do to use this version.
2. Replace all `MaterialApp`'s with `ShadeApp`, and remove `theme` and `darkTheme` parameters (if present). However, you can customize the theme using the `customThemeProperties` parameter.

## How to use
Want to use ShadeUI in your Flutter project? Here's how.

### 1. Add to pubspec.yaml
Open the projects `pubspec.yaml` file and add this under the `dependencies` section:
```yaml
shade_ui:
  git:
    url: https://github.com/Jappe-OS/ShadeUI.git
    ref: master-2.0
```
This will add the Shade UI's repository's main branch as a dependency.


You'll then need to add the `provider` package using the following command:
```
flutter pub add provider
```
This is needed for the theming system.

### 2. main.dart
Just replace your `MaterialApp` with `ShadeApp` (Won't work with Cupertino), also remember to import the ShadeUI package:
```dart
import 'package:shade_ui/shade_ui.dart';
```
The `theme` and `darkTheme` parameters that you might've used, will not be usable with `ShadeApp`, remove those. Use `customThemeProperties` instead, to change theme properties in runtime, see `Provider` and `ShadeCustomThemeProperties`.

Here is a simple example of `ShadeApp`'s usage:
```dart
ShadeApp(
  customThemeProperties: ShadeCustomThemeProperties(ThemeMode.light, null),
  home: Scaffold(
    body: const Center(child: Text('Hello!')),
    floatingActionButton: FloatingActionButton.large(onPressed: () {}, child: const Icon(Icons.add)),
  ),
),
```

### 3. Done!
You should now be able to use all of the Shade UI within your app!

* If you encounter any problems, join the Discord server (link on organization's main page).
* If you encounter a bug, please report it to the `issues` section.

Important resources:
* [Shade UI](https://github.com/Jappe-OS/ShadeUI)
* [Shade Theming](https://github.com/Jappe-OS/ShadeTheming)