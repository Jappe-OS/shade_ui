import 'package:flutter/material.dart';

/*
Credit: ubuntu/yaru.dart
https://github.com/ubuntu/yaru.dart/
*/

class ShadeUIColors {
  const ShadeUIColors._({
    required this.error,
    required this.success,
    required this.warning,
    required this.link,
  });

  /// Colors derived from the given [brightness].
  factory ShadeUIColors.from(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return ShadeUIColors.light;
      case Brightness.dark:
        return ShadeUIColors.dark;
      default:
        throw Exception("Unknown brightness: $brightness");
    }
  }

  /// Colors for the given [context].
  static ShadeUIColors of(BuildContext context) {
    return ShadeUIColors.from(Theme.of(context).brightness);
  }

  /// Theme-specific colors for light themes.
  static const light = ShadeUIColors._(
    error: Color(0xFFB52A4A), // YaruColors.red[700],
    success: Color(0xFF0e8420),
    warning: Color(0xFFf99b11),
    link: Color(0xFF0073E5), // YaruColors.blue[700],
  );

  /// Theme-specific colors for dark themes.
  static const dark = ShadeUIColors._(
    error: Color(0xFFE86581), // YaruColors.red[300]
    success: Color(0xFF0e8420),
    warning: Color(0xFFf99b11),
    link: Color(0xFF0094FF), // YaruColors.blue[500]
  );

  static const Color orange = Color(0xFFE95420);

  static const Color brighterLightBg = Color.fromARGB(255, 190, 190, 190);
  static const Color brighterDarkBg = Color.fromARGB(255, 47, 47, 47);

  /// Text Grey
  ///
  /// Text grey is used for small size headings, sub-headings and body copy text
  /// only.
  static const Color textGrey = Color(0xFF111111);

  /// Error
  final Color error;

  /// Warning
  final Color warning;

  /// Success
  final Color success;

  static const Color lightBg = Color(0xFFFAFAFA);
  static const Color darkBg = Color.fromARGB(255, 20, 20, 20);
  static const Color titleBarLight = Color(0xFFEBEBEB);
  static const Color titleBarDark = Color.fromARGB(255, 42, 42, 42);

  /// Link
  final Color link;
}

/// Set of useful methods when working with [Color]
extension ShadeUIColorExtension on Color {
  /// Blend this color with the [other] color with the specified [amount].
  Color blend(Color other, double amount) {
    int blendedRed = (red + (other.red - red) * amount).round();
    int blendedGreen = (green + (other.green - green) * amount).round();
    int blendedBlue = (blue + (other.blue - blue) * amount).round();
    int blendedAlpha = (alpha + (other.alpha - alpha) * amount).round();

    return Color.fromARGB(blendedAlpha, blendedRed, blendedGreen, blendedBlue);
  }

  /// Scale color attributes relatively to current ones.
  /// [alpha], [hue], [saturation] and [lightness] values must be clamped between -1.0 and 1.0
  Color scale({
    double alpha = 0.0,
    double hue = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= -1.0 && alpha <= 1.0);
    assert(hue >= -1.0 && hue <= 1.0);
    assert(saturation >= -1.0 && saturation <= 1.0);
    assert(lightness >= -1.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    double scale(double value, double amount, [double upperLimit = 1.0]) {
      var result = value;

      if (amount > 0) {
        result = value + (upperLimit - value) * amount;
      } else if (amount < 0) {
        result = value + value * amount;
      }

      return result.clamp(0.0, upperLimit);
    }

    return hslColor
        .withAlpha(scale(opacity, alpha))
        .withHue(scale(hslColor.hue, hue, 360.0))
        .withSaturation(scale(hslColor.saturation, saturation))
        .withLightness(scale(hslColor.lightness, lightness))
        .toColor();
  }

  /// Adjust color attributes by the given values.
  /// [alpha], [saturation] and [lightness] values must be clamped between -1.0 and 1.0
  /// [hue] value must be clamped between -360.0 and 360.0
  Color adjust({
    double alpha = 0.0,
    double hue = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= -1.0 && alpha <= 1.0);
    assert(hue >= -360.0 && hue <= 360.0);
    assert(saturation >= -1.0 && saturation <= 1.0);
    assert(lightness >= -1.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    double adjust(double value, double amount, [double upperLimit = 1.0]) {
      return (value + amount).clamp(0.0, upperLimit);
    }

    return hslColor
        .withAlpha(adjust(hslColor.alpha, alpha))
        .withHue(adjust(hslColor.hue, hue, 360.0))
        .withSaturation(adjust(hslColor.saturation, saturation))
        .withLightness(adjust(hslColor.lightness, lightness))
        .toColor();
  }

  /// Return a copy of this color with attributes replaced by given values.
  /// [alpha], [saturation] and [lightness] values must be clamped between 0.0 and 1.0
  /// [hue] value must be clamped between 0.0 and 360.0
  Color copyWith({
    double? alpha,
    double? hue,
    double? saturation,
    double? lightness,
  }) {
    assert(alpha == null || (alpha >= 0.0 && alpha <= 1.0));
    assert(hue == null || (hue >= 0.0 && hue <= 360.0));
    assert(saturation == null || (saturation >= 0.0 && saturation <= 1.0));
    assert(lightness == null || (lightness >= 0.0 && lightness <= 1.0));

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(alpha ?? hslColor.alpha)
        .withHue(hue ?? hslColor.hue)
        .withSaturation(saturation ?? hslColor.saturation)
        .withLightness(lightness ?? hslColor.lightness)
        .toColor();
  }

  Color cap({
    double alpha = 1.0,
    double saturation = 1.0,
    double lightness = 1.0,
  }) {
    assert(alpha >= 0.0 && alpha <= 1.0);
    assert(saturation >= 0.0 && saturation <= 1.0);
    assert(lightness >= 0.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(hslColor.alpha <= alpha ? hslColor.alpha : alpha)
        .withSaturation(
          hslColor.saturation <= saturation ? hslColor.saturation : saturation,
        )
        .withLightness(
          hslColor.lightness <= lightness ? hslColor.lightness : lightness,
        )
        .toColor();
  }

  Color capDown({
    double alpha = 0.0,
    double saturation = 0.0,
    double lightness = 0.0,
  }) {
    assert(alpha >= 0.0 && alpha <= 1.0);
    assert(saturation >= 0.0 && saturation <= 1.0);
    assert(lightness >= 0.0 && lightness <= 1.0);

    final hslColor = _getPatchedHslColor();

    return hslColor
        .withAlpha(hslColor.alpha >= alpha ? hslColor.alpha : alpha)
        .withSaturation(
          hslColor.saturation >= saturation ? hslColor.saturation : saturation,
        )
        .withLightness(
          hslColor.lightness >= lightness ? hslColor.lightness : lightness,
        )
        .toColor();
  }

  HSLColor _getPatchedHslColor() {
    final hslColor = HSLColor.fromColor(this);

    // A pure dark color have saturation level at 1.0, which results in red when lighten it.
    // We reset this value to 0.0, so the result is desaturated as expected:
    return hslColor
        .withSaturation(hslColor.lightness == 0.0 ? 0.0 : hslColor.saturation);
  }

  /// Returns a hex representation (`#AARRGGBB`) of the color.
  String toHex() {
    return '#${alpha.toHex()}${red.toHex()}${green.toHex()}${blue.toHex()}';
  }
}

extension on int {
  String toHex() => toRadixString(16).padLeft(2, '0');
}