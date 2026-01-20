import 'package:flutter/material.dart';

class PressableButton extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final VoidCallback onTap;
  const PressableButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.onTap,
  });
  @override
  State<PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<PressableButton> {
  bool _isPressed = false;

  late final Color _darkColor;
  late final Color _baseColor;

  @override
  void initState() {
    super.initState();
    final hsl = HSLColor.fromColor(widget.backgroundColor);
    _baseColor = widget.backgroundColor;
    _darkColor = hsl
        .withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(0, _isPressed ? 3 : 0, 0),
          decoration: BoxDecoration(
            color: _darkColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (!_isPressed)
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Container(
            height: 45,
            padding: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: _baseColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: widget.textColor,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
    );
  }
}
