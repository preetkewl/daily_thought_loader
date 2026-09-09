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
    testWidgets('renders nothing when thoughts list is empty', (
        tester,
        ) async {
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

    testWidgets('shows the first thought initially', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'First thought',
          author: 'Author 1',
        ),
        DailyThought(
          text: 'Second thought',
          author: 'Author 2',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.text('First thought'), findsOneWidget);
      expect(find.text('Author 1'), findsOneWidget);

      expect(find.text('Second thought'), findsNothing);
      expect(find.text('Author 2'), findsNothing);
    });

    testWidgets('moves to the next thought after duration', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'First thought',
          author: 'Author 1',
        ),
        DailyThought(
          text: 'Second thought',
          author: 'Author 2',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.text('First thought'), findsOneWidget);
      expect(find.text('Second thought'), findsNothing);

      await tester.pump(const Duration(milliseconds: 1001));

      expect(find.text('First thought'), findsNothing);
      expect(find.text('Second thought'), findsOneWidget);
      expect(find.text('Author 2'), findsOneWidget);
    });

    testWidgets('animates progress from 0 to 100 percent', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

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

    testWidgets('uses the custom progress widget', (
        tester,
        ) async {
      const progressKey = Key('custom-progress');

      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            progressWidget: SizedBox(
              key: progressKey,
              width: 20,
              height: 20,
            ),
          ),
        ),
      );

      expect(find.byKey(progressKey), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsNothing);
    });

    testWidgets('uses the default progress widget', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

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

    testWidgets('applies custom progress height', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

      const style = DailyThoughtLoaderStyle(
        progressHeight: 12,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            style: style,
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );

      expect(indicator.minHeight, 12);
    });

    testWidgets('applies custom thought and author styles', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

      const thoughtStyle = TextStyle(
        fontSize: 24,
      );

      const authorStyle = TextStyle(
        fontSize: 14,
      );

      const style = DailyThoughtLoaderStyle(
        thoughtTextStyle: thoughtStyle,
        authorTextStyle: authorStyle,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            style: style,
          ),
        ),
      );

      final textWidgets = tester.widgetList<Text>(
        find.byType(Text),
      ).toList();

      expect(
        textWidgets.any((text) => text.style == thoughtStyle),
        isTrue,
      );

      expect(
        textWidgets.any((text) => text.style == authorStyle),
        isTrue,
      );
    });

    testWidgets('calls onComplete after the final thought', (
        tester,
        ) async {
      var completed = false;

      const thoughts = [
        DailyThought(
          text: 'First thought',
          author: 'Author 1',
        ),
        DailyThought(
          text: 'Second thought',
          author: 'Author 2',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            onComplete: () {
              completed = true;
            },
          ),
        ),
      );

      expect(completed, isFalse);

      await tester.pump(const Duration(milliseconds: 1001));

      expect(completed, isFalse);

      await tester.pump(const Duration(milliseconds: 1001));

      expect(completed, isTrue);
    });

    testWidgets('calls onComplete only once', (
        tester,
        ) async {
      var completionCount = 0;

      const thoughts = [
        DailyThought(
          text: 'Only thought',
          author: 'Author',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: const Duration(seconds: 1),
            onComplete: () {
              completionCount++;
            },
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1001));

      expect(completionCount, 1);

      await tester.pump(const Duration(seconds: 2));

      expect(completionCount, 1);
    });

    testWidgets('does not call onComplete for an empty list', (
        tester,
        ) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: DailyThoughtLoader(
            thoughts: const [],
            duration: const Duration(seconds: 1),
            onComplete: () {
              completed = true;
            },
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      expect(completed, isFalse);
    });

    testWidgets('resets to the first thought when thoughts change', (
        tester,
        ) async {
      const initialThoughts = [
        DailyThought(
          text: 'First thought',
          author: 'Author 1',
        ),
        DailyThought(
          text: 'Second thought',
          author: 'Author 2',
        ),
      ];

      const updatedThoughts = [
        DailyThought(
          text: 'New first thought',
          author: 'New author',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: initialThoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1001));

      expect(find.text('Second thought'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: updatedThoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.text('New first thought'), findsOneWidget);
      expect(find.text('New author'), findsOneWidget);
    });

    testWidgets('stops animation when thoughts become empty', (
        tester,
        ) async {
      const initialThoughts = [
        DailyThought(
          text: 'First thought',
          author: 'Author',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: initialThoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: [],
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);

      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('displays the custom logo widget', (
        tester,
        ) async {
      const logoKey = Key('custom-logo');

      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
            logoWidget: SizedBox(
              key: logoKey,
              width: 50,
              height: 50,
            ),
          ),
        ),
      );

      expect(find.byKey(logoKey), findsOneWidget);
    });

    testWidgets('does not display a logo when none is provided', (
        tester,
        ) async {
      const thoughts = [
        DailyThought(
          text: 'Test thought',
          author: 'Author',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: DailyThoughtLoader(
            thoughts: thoughts,
            duration: Duration(seconds: 1),
          ),
        ),
      );

      expect(find.byType(FlutterLogo), findsNothing);
    });
  });
}