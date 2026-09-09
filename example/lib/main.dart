import 'package:daily_thought_loader/daily_thought_loader.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

const _thoughts = [
  DailyThought(
    text:
        "Courage doesn't always roar. Sometimes courage is the little voice at "
        "the end of the day that says 'I'll try again tomorrow'.",
    author: 'MARY ANNE RADMACHER',
  ),
  DailyThought(
    text: 'The journey of a thousand miles begins with a single step.',
    author: 'LAO TZU',
  ),
  DailyThought(
    text: 'Success is the sum of small efforts, repeated day in and day out.',
    author: 'ROBERT COLLIER',
  ),
];

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C4A2D),
      surface: const Color(0xFFF6F1EA),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: scheme, useMaterial3: true),
      home: Scaffold(
        body: DailyThoughtLoader(
          thoughts: _thoughts,
          duration: const Duration(seconds: 6),
          logoWidget: const _Wordmark(),
          style: DailyThoughtLoaderStyle(
            progressColor: const Color(0xFFF39B2D),
            thoughtTextStyle: TextStyle(color: scheme.onSurface),
          ),
          onComplete: () => debugPrint('done'),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'MEOW DOKU',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
