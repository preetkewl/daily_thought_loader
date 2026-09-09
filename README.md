# daily_thought_loader

A splash-style loading widget for Flutter.

Show a single random thought from a list while your app does startup work
(checking connectivity, loading resources, warming caches). An animated
`0%` to `100%` progress bar runs for a configurable duration, then a
completion callback fires so you can move on to the next screen.

## Features

- Displays one random thought from the provided list.
- Full-screen three-band layout: logo on top, thought centred, progress at the bottom.
- Configurable display duration.
- Animated `0%` to `100%` progress bar with rounded caps and a handle that rides along it.
- Sensible defaults resolved from your `ThemeData`; scales up on tablets.
- Deep styling hooks: background colour/gradient, padding, max width, text alignment, decorative quotation mark, author accent rule, and more.
- Quote fades and rises in on appearance (respects reduced-motion).
- `onComplete` callback fired once (post-frame) when the duration elapses.
- Injectable `Random` for deterministic tests.

## Layout

```
        ┌───────────────────────────┐
        │           logo            │  logoWidget (optional)
        │                           │
        │            “              │
        │   "the chosen thought"    │  one random entry, centred
        │        — AUTHOR           │
        │                           │
        │   ●━━━━━━━━━━━━━━━━━━━━    │  progress (pinned to bottom)
        └───────────────────────────┘
```

## Installation

Add `daily_thought_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  daily_thought_loader: ^0.2.0
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

The default handle is a small glowing dot in the progress colour. The handle
rides in its own lane above the track and is inset so it never clips at the
ends.

## Custom Logo

An optional widget pinned to the top of the screen:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  logoWidget: Image.asset('assets/logo.png', width: 120),
)
```

The loader does not require a logo.

## Styling

Everything is optional — unset values resolve from `Theme.of(context)` and the
screen size. Override only what you need:

```dart
DailyThoughtLoader(
  thoughts: thoughts,
  duration: const Duration(seconds: 5),
  style: DailyThoughtLoaderStyle(
    backgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF6F1EA), Color(0xFFEFE6DA)],
    ),
    progressColor: const Color(0xFFF39B2D),
    maxContentWidth: 600,
    textAlign: TextAlign.center,
    thoughtTextStyle: const TextStyle(fontWeight: FontWeight.w700),
    authorTextStyle: const TextStyle(letterSpacing: 1.6),
    showQuotationMark: true,
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
| `progressWidget` | `Widget?` | Handle that moves along the progress bar. Defaults to a glowing dot. |
| `logoWidget` | `Widget?` | Optional widget pinned to the top. |
| `style` | `DailyThoughtLoaderStyle` | Visual styling configuration. |
| `onComplete` | `VoidCallback?` | Called once (post-frame) when the duration elapses. |
| `random` | `Random?` | Random source for the pick. Defaults to `Random()`. |

### `DailyThoughtLoaderStyle`

Controls the visual appearance of the loader. All fields are optional.

| Property | Type | Default |
|---|---|---|
| `backgroundColor` | `Color?` | `colorScheme.surface` |
| `backgroundGradient` | `Gradient?` | — (wins over `backgroundColor`) |
| `contentPadding` | `EdgeInsetsGeometry?` | responsive (larger on tablets) |
| `maxContentWidth` | `double` | `560` |
| `textAlign` | `TextAlign` | `TextAlign.center` |
| `fontFamily` | `String?` | inherit (applies to quote, author, quote mark) |
| `fontFamilyFallback` | `List<String>?` | — |
| `logoSpacing` | `double` | `32` |
| `thoughtSpacing` | `double` | `20` |
| `showQuotationMark` | `bool` | `true` |
| `quotationMarkColor` | `Color?` | progress colour @ 18% |
| `thoughtTextStyle` | `TextStyle?` | merged over resolved default |
| `authorTextStyle` | `TextStyle?` | merged over resolved default |
| `showAuthorSeparator` | `bool` | `true` |
| `authorSeparatorColor` | `Color?` | progress colour @ 60% |
| `progressHeight` | `double` | `6` |
| `progressColor` | `Color?` | `colorScheme.primary` |
| `progressBackgroundColor` | `Color?` | progress colour @ 15% |
| `progressBorderRadius` | `BorderRadiusGeometry?` | fully rounded |
| `progressSectionHeight` | `double` | `36` (handle lane) |
| `progressHandleInset` | `double` | `20` |
| `animateIn` | `bool` | `true` |

## License

This package is released under the MIT License. See [LICENSE](LICENSE) for details.