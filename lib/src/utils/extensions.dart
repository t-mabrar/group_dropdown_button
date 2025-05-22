import 'package:flutter/material.dart';

/// An extension on [BuildContext] to provide convenient access to
/// commonly used [MediaQuery] and [Theme] properties.
/// This promotes cleaner, more readable code across the app.
extension AppContext on BuildContext {
  /// Returns the screen width using [MediaQuery].
  double get width => MediaQuery.of(this).size.width;

  /// Returns the screen height using [MediaQuery].
  double get height => MediaQuery.of(this).size.height;

  /// Provides access to the current [TextTheme] from the app's theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the primary color from the current theme's [ColorScheme].
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Returns the secondary color from the current theme's [ColorScheme].
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Returns the default border color used in input decorations.
  /// Falls back to [Colors.black] if no border is defined.
  Color get borderColor =>
      Theme.of(this).inputDecorationTheme.border == null
          ? Colors.black
          : Theme.of(this).inputDecorationTheme.border!.borderSide.color;

  /// Returns the color of the enabled border in input decorations.
  /// Defaults to [Colors.black] if not explicitly defined in the theme.
  Color get enabledBorderColor =>
      Theme.of(this).inputDecorationTheme.enabledBorder == null
          ? Colors.black
          : Theme.of(this).inputDecorationTheme.enabledBorder!.borderSide.color;

  /// Returns the error color defined in the theme's [ColorScheme].
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Returns the default icon color from the current theme.
  /// Falls back to [Colors.black] if not set.
  Color get iconColor => Theme.of(this).iconTheme.color ?? Colors.black;
}
