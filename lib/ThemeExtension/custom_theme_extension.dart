import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final BoxShadow boxShadow;

  CustomThemeExtension({required this.boxShadow});

  @override
  CustomThemeExtension copyWith({BoxShadow? boxShadow}) {
    return CustomThemeExtension(
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      boxShadow: BoxShadow.lerp(boxShadow, other.boxShadow, t)!,
    );
  }
}