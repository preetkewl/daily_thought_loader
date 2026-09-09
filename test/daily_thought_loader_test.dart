import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_thought_loader/daily_thought_loader.dart';

void main() {
  group('DailyThought', () {
    test('stores text and author', () {
      const thought = DailyThought(
        text: 'Stay curious.',
        author: 'Unknown',
      );

      expect(thought.text, 'Stay curious.');
      expect(thought.author, 'Unknown');
    });

    test('allows an empty author', () {
      const thought = DailyThought(
        text: 'Keep going.',
        author: '',
      );

      expect(thought.text, 'Keep going.');
      expect(thought.author, '');
    });
  });

  group('DailyThoughtLoader', () {
    testWidgets('renders nothing when thoughts list is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: [],
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('shows a single thought from the pool', (tester) async {
      const thoughts = [
        DailyThought(text: 'First thought', author: 'Author 1'),
        DailyThought(text: 'Second thought', author: 'Author 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            random: Random(0),
          ),
        ),
      );

      final shownFirst = find.text('First thought').evaluate().isNotEmpty;
      final shownSecond = find.text('Second thought').evaluate().isNotEmpty;

      expect(shownFirst ^ shownSecond, isTrue,
          reason: 'exactly one thought should be displayed');
    });

    testWidgets('does not advance to another thought after the duration',
        (tester) async {
      const thoughts = [
        DailyThought(text: 'First thought', author: 'Author 1'),
        DailyThought(text: 'Second thought', author: 'Author 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            random: Random(0),
          ),
        ),
      );

      final textFinder = find.byType(Text);
      final shown = tester.widget<Text>(textFinder.first).data;

      await tester.pump(const Duration(milliseconds: 1001));
      await tester.pump(const Duration(seconds: 2));

      expect(tester.widget<Text>(find.byType(Text).first).data, shown);
    });

    testWidgets('uses a seeded Random for a deterministic pick', (tester) async {
      const thoughts = [
        DailyThought(text: 'A', author: ''),
        DailyThought(text: 'B', author: ''),
        DailyThought(text: 'C', author: ''),
        DailyThought(text: 'D', author: ''),
      ];

      final expected = thoughts[Random(42).nextInt(thoughts.length)].text;

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            random: Random(42),
          ),
        ),
      );

      expect(find.text(expected), findsOneWidget);
    });

    testWidgets('animates progress from 0 to 100 percent', (tester) async {
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      var indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.0, 0.01));

      await tester.pump(const Duration(milliseconds: 500));
      indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(0.5, 0.05));

      await tester.pump(const Duration(milliseconds: 500));
      indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, closeTo(1.0, 0.01));
    });

    testWidgets('hides the author row when the author is empty', (tester) async {
      const thoughts = [DailyThought(text: 'No attribution', author: '')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('No attribution'), findsOneWidget);
    });

    testWidgets('uses the custom progress widget', (tester) async {
      const progressKey = Key('custom-progress');
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            progressWidget: SizedBox(key: progressKey, width: 20, height: 20),
          ),
        ),
      );

      expect(find.byKey(progressKey), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsNothing);
    });

    testWidgets('uses the default progress widget', (tester) async {
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.byIcon(Icons.circle), findsOneWidget);
    });

    testWidgets('applies custom progress height', (tester) async {
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            style: DailyThoughtLoaderStyle(progressHeight: 12),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(indicator.minHeight, 12);
    });

    testWidgets('applies custom thought and author styles', (tester) async {
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];
      const thoughtStyle = TextStyle(fontSize: 24);
      const authorStyle = TextStyle(fontSize: 14);

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            style: DailyThoughtLoaderStyle(
              thoughtTextStyle: thoughtStyle,
              authorTextStyle: authorStyle,
            ),
          ),
        ),
      );

      final textWidgets =
          tester.widgetList<Text>(find.byType(Text)).toList();

      expect(textWidgets.any((text) => text.style == thoughtStyle), isTrue);
      expect(textWidgets.any((text) => text.style == authorStyle), isTrue);
    });

    testWidgets('calls onComplete once after the duration', (tester) async {
      var completionCount = 0;
      const thoughts = [DailyThought(text: 'Only thought', author: 'Author')];

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            onComplete: () => completionCount++,
          ),
        ),
      );

      expect(completionCount, 0);

      await tester.pump(const Duration(milliseconds: 1001));
      await tester.pump(); // flush the post-frame callback

      expect(completionCount, 1);

      await tester.pump(const Duration(seconds: 2));
      expect(completionCount, 1);
    });

    testWidgets('does not call onComplete for an empty list', (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: const [],
            duration: const Duration(seconds: 1),
            onComplete: () => completed = true,
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(completed, isFalse);
    });

    testWidgets('picks a fresh thought when the pool changes', (tester) async {
      const initial = [DailyThought(text: 'Initial thought', author: '')];
      const updated = [DailyThought(text: 'Updated thought', author: '')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: initial,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.text('Initial thought'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: updated,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.text('Updated thought'), findsOneWidget);
      expect(find.text('Initial thought'), findsNothing);
    });

    testWidgets('restarts progress when the duration changes', (tester) async {
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 900));

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 4),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(indicator.value, closeTo(0.0, 0.01));
    });

    testWidgets('displays the custom logo widget', (tester) async {
      const logoKey = Key('custom-logo');
      const thoughts = [DailyThought(text: 'Test thought', author: 'Author')];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            logoWidget: SizedBox(key: logoKey, width: 50, height: 50),
          ),
        ),
      );

      expect(find.byKey(logoKey), findsOneWidget);
    });
  });
}
