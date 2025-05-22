import 'package:flutter/material.dart';

extension AppContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  // bool get isMobile {
  //   return MediaQuery.of(this).size.width < 480.0;
  // }

  bool get isBigScreen => MediaQuery.of(this).size.width > 768.0;

  bool get isTab =>
      MediaQuery.of(this).size.width > 480.0 &&
      MediaQuery.of(this).size.width < 768.0;

  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get redColor => Theme.of(this).colorScheme.error;
  Color get iconColor => Theme.of(this).iconTheme.color ?? Colors.black;
}
