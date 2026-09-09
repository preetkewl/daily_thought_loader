import 'package:flutter/material.dart';

/// Defines the visual styling for [DailyThoughtLoader].
@immutable
class DailyThoughtLoaderStyle {
  /// Creates a style configuration for [DailyThoughtLoader].
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

  /// The height of the progress bar.
  final double progressHeight;

  /// The background color of the progress bar.
  final Color? progressBackgroundColor;

  /// The color of the progress indicator.
  final Color? progressColor;

  /// The total height allocated to the progress section.
  ///
  /// This includes the space required by the moving progress widget.
  final double progressSectionHeight;

  /// The text style used for the thought.
  final TextStyle? thoughtTextStyle;

  /// The text style used for the author.
  final TextStyle? authorTextStyle;

  /// The vertical spacing between thought content and the progress section.
  final double thoughtSpacing;

  /// The vertical spacing between the progress section and the logo.
  final double logoSpacing;
}