import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String label;
  final bool isEnabled;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.label,
    this.isEnabled = true,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Material(
            color: widget.isEnabled
                ? widget.backgroundColor
                : widget.backgroundColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            elevation: widget.isEnabled ? 4 : 1,
            child: InkWell(
              onTap: widget.isEnabled ? _handleTap : null,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: widget.isEnabled
                  ? widget.backgroundColor
                  : widget.backgroundColor.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
