import 'package:flutter/material.dart';

/// Defines the visual styling for [DailyThoughtLoader].
///
/// Every value is optional. Anything left `null` is resolved from the ambient
/// [ThemeData] and the screen size (phone vs. tablet) at build time, so the
/// defaults look intentional without any configuration.
@immutable
class DailyThoughtLoaderStyle {
  /// Creates a style configuration for [DailyThoughtLoader].
  const DailyThoughtLoaderStyle({
    this.backgroundColor,
    this.backgroundGradient,
    this.contentPadding,
    this.maxContentWidth = 560.0,
    this.textAlign = TextAlign.center,
    this.fontFamily,
    this.fontFamilyFallback,
    this.logoSpacing = 32.0,
    this.thoughtSpacing = 20.0,
    this.showQuotationMark = true,
    this.quotationMarkColor,
    this.thoughtTextStyle,
    this.authorTextStyle,
    this.showAuthorSeparator = true,
    this.authorSeparatorColor,
    this.progressHeight = 6.0,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressBorderRadius,
    this.progressSectionHeight = 36.0,
    this.progressHandleInset = 20.0,
    this.animateIn = true,
  });

  /// Solid background colour. Ignored when [backgroundGradient] is set.
  ///
  /// Defaults to `Theme.of(context).colorScheme.surface`.
  final Color? backgroundColor;

  /// Background gradient. Takes precedence over [backgroundColor].
  final Gradient? backgroundGradient;

  /// Outer padding around the logo / quote / loader column.
  ///
  /// Defaults to a responsive value (larger on tablets).
  final EdgeInsetsGeometry? contentPadding;

  /// Maximum width of the content column. Keeps line length readable on
  /// tablets. The column is centred horizontally within the available space.
  final double maxContentWidth;

  /// Horizontal alignment of the quote and author text.
  final TextAlign textAlign;

  /// Font family applied to the quote, the author, and the decorative
  /// quotation mark.
  ///
  /// Individual [thoughtTextStyle] / [authorTextStyle] values still win, so
  /// you can override the family for one of them. To use a family bundled by
  /// another package, prefix it, e.g. `packages/my_fonts/Lora`.
  final String? fontFamily;

  /// Ordered fallback families used when a glyph is missing from
  /// [fontFamily].
  final List<String>? fontFamilyFallback;

  /// Vertical gap between the logo and the quote area.
  final double logoSpacing;

  /// Vertical gap between the quote and the author line.
  final double thoughtSpacing;

  /// Whether to draw the large decorative opening quotation mark above the
  /// quote.
  final bool showQuotationMark;

  /// Colour of the decorative quotation mark.
  ///
  /// Defaults to the progress colour at low opacity.
  final Color? quotationMarkColor;

  /// Text style for the quote. Merged over the resolved default.
  final TextStyle? thoughtTextStyle;

  /// Text style for the author. Merged over the resolved default.
  final TextStyle? authorTextStyle;

  /// Whether to draw a short accent rule beside the author name.
  final bool showAuthorSeparator;

  /// Colour of the author accent rule. Defaults to the progress colour.
  final Color? authorSeparatorColor;

  /// Thickness of the progress track.
  final double progressHeight;

  /// Colour of the progress fill (and, by default, the accents).
  ///
  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? progressColor;

  /// Colour of the progress track behind the fill.
  ///
  /// Defaults to the progress colour at low opacity.
  final Color? progressBackgroundColor;

  /// Corner radius of the progress track and fill.
  ///
  /// Defaults to fully rounded caps (`progressHeight / 2`).
  final BorderRadiusGeometry? progressBorderRadius;

  /// Height of the lane above the track in which the moving progress widget
  /// (the "handle") travels.
  final double progressSectionHeight;

  /// Horizontal inset applied to the handle's travel so it never clips at
  /// `0%` / `100%`.
  final double progressHandleInset;

  /// Whether the quote fades and rises in when it first appears (and whenever
  /// a new thought is picked). Ignored when the platform requests reduced
  /// motion.
  final bool animateIn;
}
