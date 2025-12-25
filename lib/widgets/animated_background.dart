import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated gradient background with subtle movement
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.surface,
                      colorScheme.surface.withOpacity(0.8),
                      colorScheme.primary.withOpacity(0.1),
                    ]
                  : [
                      colorScheme.primary.withOpacity(0.05),
                      colorScheme.surface,
                      colorScheme.secondary.withOpacity(0.05),
                    ],
              stops: [
                0.0,
                0.5 + math.sin(_controller.value * 2 * math.pi) * 0.1,
                1.0,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
