# Shade UI
An UI elements package used by JappeOS apps.

## How to use
Want to use Shade UI in your Flutter project? Here's how.

### 1. Add to pubspec.yaml
Open the projects 'pubspec.yaml' file and add this under the 'dependencies' section:
```yaml
shade_ui:
  git:
    url: https://github.com/Jappe-OS/ShadeUI.git
    ref: master
```
This will add the Shade UI's repositorys main branch as a dependency.


Shade Theming should also be added to the 'dependencies' section:
```yaml
shade_theming:
  git:
    url: https://github.com/Jappe-OS/ShadeTheming.git
    ref: master
```
Shade Theming is a package that allows you to theme the UI widgets.


You'll then need to add the 'provider' package using the following command:
```
flutter pub add provider
```
This is needed for the theming system.

### 2. main.dart
#### Setting theme properties
In your 'main.dart' file, within the 'void main()' function, add the following code above the 'runApp()' function:
```dart
ShadeTheme.setThemeProperties(arg0, arg1);
```
* arg0: The dark theme's theme data.
* arg1: The light theme's theme data.

NOTE: Make sure to import the correct packages.

The function needs a dark and a light theme's theme data, like this:
```dart
ShadeTheme.setThemeProperties(DarkThemeProperties(ThemeProperties(/*...*/)), LightThemeProperties(ThemeProperties(/*...*/)));
```
The commented '/*...*/' bit should be replaced with the constructor's parameters; see: [theming.dart](https://github.com/Jappe-OS/ShadeTheming/blob/master/lib/theming.dart).

Both 'DarkThemeProperties' and 'LightThemeProperties' take in a 'ThemeProperties' object.

#### Provider set-up
Now, we'll need to modify the 'runApp()' function within the 'void main()' function. This function takes in a 'Widget' type. Add a 'MultiProvider' and move the widget (from the old 'runApp()') to the 'child: ' parameter of the 'MultiProvider' object, make sure that the 'MultiProvider' object is inside the 'runApp()' function.
Now, we can add this above the 'child: ' parameter:
```dart
providers: [
    ChangeNotifierProvider<ShadeThemeProvider>(create: (_) => ShadeThemeProvider())
],
```
This will make the theme work correctly.

### 3. Done!
You should now be able to use all of the Shade UI's widgets within your app!

Important resources:
* [Shade UI](https://github.com/Jappe-OS/ShadeUI)
* [Shade Theming](https://github.com/Jappe-OS/ShadeTheming)