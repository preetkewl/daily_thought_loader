import 'package:flutter/foundation.dart';

@immutable
class DailyThought {
  const DailyThought({
    required this.text,
    required this.author,
  });

  final String text;
  final String author;
}