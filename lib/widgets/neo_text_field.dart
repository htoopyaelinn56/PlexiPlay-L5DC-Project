import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class NeoTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const NeoTextField({
    super.key,
    required this.labelText,
    this.hintText = '',
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: NeoTheme.boxDecoration(
            color: NeoTheme.white,
            borderRadius: NeoTheme.radiusMain,
          ),
          child: TextField(
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: NeoTheme.black.withOpacity(0.4),
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(NeoTheme.radiusMain),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
