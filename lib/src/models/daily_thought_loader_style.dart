import 'package:flutter/material.dart';

@immutable
class DailyThoughtLoaderStyle {
  const DailyThoughtLoaderStyle({
    this.progressHeight = 4.0,
    this.progressBackgroundColor,
    this.progressColor,
    this.progressSectionHeight = 48.0,
    this.thoughtTextStyle,
    this.authorTextStyle,
    this.thoughtSpacing = 8.0,
    this.logoSpacing = 24.0,
  });

  final double progressHeight;
  final Color? progressBackgroundColor;
  final Color? progressColor;
  final double progressSectionHeight;
  final TextStyle? thoughtTextStyle;
  final TextStyle? authorTextStyle;
  final double thoughtSpacing;
  final double logoSpacing;
}