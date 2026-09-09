# daily_thought_loader

A customizable timed daily thought loading widget for Flutter.

Display a sequence of thoughts with an animated progress bar, a moving progress widget, an optional logo, customizable styling, and a completion callback.

## Features

- Display multiple daily thoughts sequentially.
- Configure how long each thought is displayed.
- Animated `0%` to `100%` progress for each thought.
- Custom widget that moves with the progress bar.
- Optional custom logo widget.
- Customizable progress bar appearance.
- Customizable thought and author text styles.
- `onComplete` callback after the final thought.
- Works as a normal composable Flutter widget.

## Installation

Add `daily_thought_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  daily_thought_loader: ^0.0.1
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

Each thought is displayed for the configured duration. The progress animation resets when the loader moves to the next thought.

After the final thought completes, `onComplete` is called once.

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
| `thoughts` | `List<DailyThought>` | Thoughts displayed in sequence. |
| `duration` | `Duration` | Time each thought remains visible. |
| `progressWidget` | `Widget` | Widget displayed above and moving with the progress bar. |
| `logoWidget` | `Widget?` | Optional widget displayed below the progress section. |
| `style` | `DailyThoughtLoaderStyle` | Visual styling configuration. |
| `onComplete` | `VoidCallback?` | Called after the final thought completes. |

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