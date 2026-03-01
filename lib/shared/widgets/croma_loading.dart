import 'package:flutter/material.dart';

class CromaLoading extends StatefulWidget {
  final double size;
  final Color? color;

  const CromaLoading({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  State<CromaLoading> createState() => _CromaLoadingState();
}

class _CromaLoadingState extends State<CromaLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF202020);
    
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring (industrial dash style)
                Transform.rotate(
                  angle: _controller.value * 2 * 3.1415,
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CircularProgressIndicator(
                      value: 0.25,
                      strokeWidth: 2,
                      color: color.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                // Inner counter-rotating ring
                Transform.rotate(
                  angle: -_controller.value * 4 * 3.1415,
                  child: SizedBox(
                    width: widget.size * 0.6,
                    height: widget.size * 0.6,
                    child: CircularProgressIndicator(
                      value: 0.4,
                      strokeWidth: 3,
                      color: color,
                    ),
                  ),
                ),
                // Minimalist dot in center
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
