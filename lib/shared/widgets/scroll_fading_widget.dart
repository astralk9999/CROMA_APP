import 'package:flutter/material.dart';

class ScrollFadingWidget extends StatefulWidget {
  final Widget child;
  final double offsetAmount;
  final Duration duration;

  const ScrollFadingWidget({
    super.key,
    required this.child,
    this.offsetAmount = 50.0,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ScrollFadingWidget> createState() => _ScrollFadingWidgetState();
}

class _ScrollFadingWidgetState extends State<ScrollFadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetAmount / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Auto-trigger on init for now. A real scroll-driven fade needs a visibility detector.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
