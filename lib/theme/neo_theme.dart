import 'package:flutter/material.dart';

class NeoTheme {
  // Palette
  static const Color cream = Color(0xFFFFF6E9);
  static const Color black = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);
  static const Color yellow = Color(0xFFFCD148);
  static const Color pink = Color(0xFFFA58B6);
  static const Color purple = Color(0xFF8C82FC);
  static const Color blue = Color(0xFF2AB7CA);
  static const Color green = Color(0xFF00C49A);

  // Borders & Shadows
  static const double borderThick = 3.0;
  static const double radiusMain = 12.0;

  static BoxDecoration boxDecoration({
    Color color = white,
    double borderRadius = radiusMain,
    bool showShadow = true,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: black, width: borderThick),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: showShadow
          ? [
              const BoxShadow(
                color: black,
                offset: Offset(4, 4),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }
}
