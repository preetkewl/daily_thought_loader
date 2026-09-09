# daily_thought_loader

A splash-style loading widget for Flutter.

Show a single random thought from a list while your app does startup work
(checking connectivity, loading resources, warming caches). An animated
`0%` to `100%` progress bar runs for a configurable duration, then a
completion callback fires so you can move on to the next screen.

## Features

- Displays one random thought from the provided list.
- Configurable display duration.
- Animated `0%` to `100%` progress bar with a widget that moves along it.
- Optional custom logo widget.
- Customizable progress bar appearance and thought/author text styles.
- `onComplete` callback fired once when the duration elapses.
- Injectable `Random` for deterministic tests.
- Works as a normal composable Flutter widget.

## Installation

Add `daily_thought_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  daily_thought_loader: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Basic Usage

```dart
import 'package:daily_thought_loader/daily_thought_loader.dart';

final thoughts = [
  const DailyThought(
    text: 'The journey of a thousand miles begins with a single step.',
    author: 'Lao Tzu',
  ),
  const DailyThought(
    text: 'Stay hungry, stay foolish.',
    author: 'Steve Jobs',
  ),
  const DailyThought(
    text: 'Success is the sum of small efforts, repeated day in and day out.',
    author: 'Robert Collier',
  ),
];
```

Use the loader in your widget:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  onComplete: () {
    // Continue to the next screen or start the game.
  },
)
```

One thought is chosen at random from `thoughts` and shown for `duration`
while the progress bar animates from `0%` to `100%`. When the duration
elapses, `onComplete` is called once. The loader does not advance to
another thought.

A new random thought is chosen (and the animation restarts) if you pass a
new `thoughts` list instance or a different `duration`. Pass a seeded
`Random` to make the selection deterministic in tests.

## Custom Progress Widget

You can provide any Flutter widget as the progress widget:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  progressWidget: const Icon(
    Icons.star,
    size: 32,
  ),
)
```

The widget moves horizontally above the progress bar as the progress changes.

## Custom Logo

An optional widget can be displayed below the progress section:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  logoWidget: Image.asset(
    'assets/logo.png',
    width: 100,
  ),
)
```

The loader does not require a logo.

## Styling

Use `DailyThoughtLoaderStyle` to customize the appearance:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  style: const DailyThoughtLoaderStyle(
    progressHeight: 6,
    progressBackgroundColor: Colors.grey,
    progressColor: Colors.blue,
    progressSectionHeight: 50,
    thoughtTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    authorTextStyle: TextStyle(
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
    thoughtSpacing: 12,
    logoSpacing: 24,
  ),
)
```

## API

### `DailyThought`

Represents a single thought.

| Property | Type | Description |
|---|---|---|
| `text` | `String` | The thought text. |
| `author` | `String` | The author of the thought. |

If a thought has no author, pass an empty string.

### `DailyThoughtLoader`

| Property | Type | Description |
|---|---|---|
| `thoughts` | `List<DailyThought>` | Pool to pick from. One entry is chosen at random. If empty, nothing renders and `onComplete` is not called. |
| `duration` | `Duration` | How long the chosen thought is shown before `onComplete`. |
| `progressWidget` | `Widget` | Widget displayed above and moving with the progress bar. |
| `logoWidget` | `Widget?` | Optional widget displayed below the progress section. |
| `style` | `DailyThoughtLoaderStyle` | Visual styling configuration. |
| `onComplete` | `VoidCallback?` | Called once (post-frame) when the duration elapses. |
| `random` | `Random?` | Random source for the pick. Defaults to `Random()`. |

### `DailyThoughtLoaderStyle`

Controls the visual appearance of the loader.

Available properties:

- `progressHeight`
- `progressBackgroundColor`
- `progressColor`
- `progressSectionHeight`
- `thoughtTextStyle`
- `authorTextStyle`
- `thoughtSpacing`
- `logoSpacing`

## License

This package is released under the MIT License. See [LICENSE](LICENSE) for details.