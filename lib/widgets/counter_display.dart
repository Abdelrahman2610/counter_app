import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CounterDisplay extends StatefulWidget {
  final int counter;
  final Animation<double> scaleAnimation;
  final bool showConfetti;

  const CounterDisplay({
    super.key,
    required this.counter,
    required this.scaleAnimation,
    this.showConfetti = false,
  });

  @override
  State<CounterDisplay> createState() => _CounterDisplayState();
}

class _CounterDisplayState extends State<CounterDisplay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void didUpdateWidget(CounterDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showConfetti && !oldWidget.showConfetti) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.2,
            shouldLoop: false,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.error,
              Colors.amber,
              Colors.green,
              Colors.pink,
            ],
          ),
        ),

        // Counter card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                // Animated counter number
                ScaleTransition(
                  scale: widget.scaleAnimation,
                  child: Text(
                    '${widget.counter}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: _getCounterColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 72,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusIndicator(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getCounterColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.counter == 0) {
      return colorScheme.onSurface.withOpacity(0.6);
    } else if (widget.counter > 0) {
      return colorScheme.primary;
    } else {
      return colorScheme.error;
    }
  }

  Widget _buildStatusIndicator(BuildContext context) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    final colorScheme = Theme.of(context).colorScheme;

    if (widget.counter == 0) {
      statusText = 'Ready to count';
      statusColor = colorScheme.onSurface.withOpacity(0.6);
      statusIcon = Icons.circle_outlined;
    } else if (widget.counter >= 999999) {
      statusText = 'Maximum reached';
      statusColor = colorScheme.error;
      statusIcon = Icons.warning_rounded;
    } else {
      statusText = 'Counting...';
      statusColor = colorScheme.primary;
      statusIcon = Icons.check_circle_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 14,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
