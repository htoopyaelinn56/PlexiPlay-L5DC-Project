import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class NeoBackButton extends StatelessWidget {
  const NeoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: NeoTheme.white,
          border: Border.all(
            color: NeoTheme.black,
            width: NeoTheme.borderThick,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: NeoTheme.black, offset: Offset(2, 2)),
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded, color: NeoTheme.black),
      ),
    );
  }
}
