import 'package:flutter/material.dart';

import '../models/daily_thought.dart';
import '../models/daily_thought_loader_style.dart';

class DailyThoughtLoader extends StatefulWidget {
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
  });

  final Widget? logoWidget;
  final List<DailyThought> thoughts;
  final Duration duration;
  final Widget progressWidget;
  final DailyThoughtLoaderStyle style;
  final VoidCallback? onComplete;

  @override
  State<DailyThoughtLoader> createState() => _DailyThoughtLoaderState();
}

class _DailyThoughtLoaderState extends State<DailyThoughtLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _currentThoughtIndex = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addStatusListener(_handleAnimationStatus);

    if (widget.thoughts.isNotEmpty) {
      _controller.forward();
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _isCompleted) {
      return;
    }

    if (_currentThoughtIndex < widget.thoughts.length - 1) {
      setState(() {
        _currentThoughtIndex++;
      });

      _controller.reset();
      _controller.forward();
      return;
    }

    _isCompleted = true;
    widget.onComplete?.call();
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
    if (widget.thoughts.isEmpty) {
      return const SizedBox.shrink();
    }

    final thought = widget.thoughts[_currentThoughtIndex];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(thought.text, style: widget.style.thoughtTextStyle),
            SizedBox(height: widget.style.thoughtSpacing),
            Text(thought.author, style: widget.style.authorTextStyle),
            SizedBox(height: widget.style.thoughtSpacing),
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

  @override
  void didUpdateWidget(covariant DailyThoughtLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.thoughts != widget.thoughts) {
      if (widget.thoughts.isEmpty) {
        _controller.stop();
        _currentThoughtIndex = 0;
        _isCompleted = false;
      } else {
        _currentThoughtIndex = 0;
        _isCompleted = false;

        _controller
          ..reset()
          ..forward();
      }
    }
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
            alignment: Alignment(progress * 2 - 1, -1),
            child: progressWidget,
          ),
        ],
      ),
    );
  }
}
