import 'dart:math';

import 'package:flutter/material.dart';

import '../models/daily_thought.dart';
import '../models/daily_thought_loader_style.dart';

/// A splash-style loader that displays a single random thought while your
/// app performs startup work (checking connectivity, loading resources, ...).
///
/// One thought is chosen at random from [thoughts] and shown for [duration]
/// with an animated `0%` to `100%` progress indicator. When the duration
/// completes, [onComplete] is called exactly once. The loader never advances
/// to another thought.
///
/// A fresh random thought is chosen if [thoughts] (by identity) or [duration]
/// changes, and the progress animation restarts.
///
/// The [progressWidget] is positioned above the progress bar and moves
/// horizontally with the progress value. An optional [logoWidget] can be
/// displayed below the progress section.
class DailyThoughtLoader extends StatefulWidget {
  /// Creates a daily thought loader.
  const DailyThoughtLoader({
    super.key,
    required this.thoughts,
    required this.duration,
    this.progressWidget = const Icon(
      Icons.circle,
      size: 32,
    ),
    this.logoWidget,
    this.style = const DailyThoughtLoaderStyle(),
    this.onComplete,
    this.random,
  });

  /// The pool of thoughts to choose from.
  ///
  /// Exactly one entry is picked at random and displayed. Provide a new list
  /// instance to trigger a fresh pick. If the list is empty, the loader
  /// renders nothing and [onComplete] is not called.
  final List<DailyThought> thoughts;

  /// The amount of time the chosen thought remains visible before
  /// [onComplete] is called.
  final Duration duration;

  /// The widget displayed above the progress bar.
  ///
  /// Its horizontal position follows the current progress value.
  final Widget progressWidget;

  /// An optional widget displayed below the progress section.
  final Widget? logoWidget;

  /// Controls the visual appearance of the loader.
  final DailyThoughtLoaderStyle style;

  /// Called exactly once when the progress animation completes.
  final VoidCallback? onComplete;

  /// The random number generator used to pick a thought.
  ///
  /// Defaults to a new [Random] instance. Provide a seeded [Random] to make
  /// the selection deterministic in tests.
  final Random? random;

  @override
  State<DailyThoughtLoader> createState() => _DailyThoughtLoaderState();
}

class _DailyThoughtLoaderState extends State<DailyThoughtLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Random _random;

  DailyThought? _thought;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _random = widget.random ?? Random();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_handleAnimationStatus);

    _startWithRandomThought();
  }

  void _startWithRandomThought() {
    if (widget.thoughts.isEmpty) {
      _thought = null;
      _isCompleted = false;
      _controller.stop();
      _controller.value = 0.0;
      return;
    }

    _thought = widget.thoughts[_random.nextInt(widget.thoughts.length)];
    _isCompleted = false;

    _controller
      ..reset()
      ..forward();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _isCompleted) {
      return;
    }

    _isCompleted = true;

    final callback = widget.onComplete;
    if (callback == null) {
      return;
    }

    // Defer so callers can safely navigate without mutating the tree
    // during the animation status phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        callback();
      }
    });
  }

  @override
  void didUpdateWidget(covariant DailyThoughtLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (!identical(oldWidget.thoughts, widget.thoughts) ||
        oldWidget.duration != widget.duration) {
      setState(_startWithRandomThought);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thought = _thought;
    if (thought == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              thought.text,
              style: widget.style.thoughtTextStyle,
            ),
            if (thought.author.isNotEmpty) ...[
              SizedBox(
                height: widget.style.thoughtSpacing,
              ),
              Text(
                thought.author,
                style: widget.style.authorTextStyle,
              ),
            ],
            SizedBox(
              height: widget.style.thoughtSpacing,
            ),
            _ProgressSection(
              progress: _controller.value,
              progressWidget: widget.progressWidget,
              style: widget.style,
            ),
            if (widget.logoWidget != null) ...[
              SizedBox(
                height: widget.style.logoSpacing,
              ),
              widget.logoWidget!,
            ],
          ],
        );
      },
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.progress,
    required this.progressWidget,
    required this.style,
  });

  final double progress;
  final Widget progressWidget;
  final DailyThoughtLoaderStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: style.progressSectionHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              minHeight: style.progressHeight,
              backgroundColor: style.progressBackgroundColor,
              valueColor: style.progressColor == null
                  ? null
                  : AlwaysStoppedAnimation<Color>(style.progressColor!),
              value: progress,
            ),
          ),
          Align(
            alignment: Alignment(
              progress * 2 - 1,
              -1,
            ),
            child: progressWidget,
          ),
        ],
      ),
    );
  }
}
