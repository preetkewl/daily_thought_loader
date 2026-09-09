import 'package:flutter/foundation.dart';

/// A thought displayed by [DailyThoughtLoader].
@immutable
class DailyThought {
  /// Creates a daily thought.
  const DailyThought({
    required this.text,
    required this.author,
  });

  /// The text of the thought.
  final String text;

  /// The author of the thought.
  ///
  /// Pass an empty string if the thought has no author.
  final String author;
}