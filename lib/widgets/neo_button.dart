import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class NeoButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Widget? icon;
  final bool isLoading;

  const NeoButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = NeoTheme.yellow,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        height: 55,
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          _isPressed ? 3.0 : 0.0,
          _isPressed ? 3.0 : 0.0,
          0.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: Border.all(
            color: NeoTheme.black,
            width: NeoTheme.borderThick,
          ),
          borderRadius: BorderRadius.circular(50.0), // Pill shape
          boxShadow: _isPressed
              ? []
              : const [
                  BoxShadow(
                    color: NeoTheme.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: widget.isLoading
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text.toUpperCase(),
                    style: const TextStyle(
                      color: NeoTheme.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
