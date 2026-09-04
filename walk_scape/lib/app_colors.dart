import 'package:flutter/material.dart';

/// WalkScape color palette
/// Derived from the provided green palette image.
class AppColors {
  AppColors._();

  static const Color mint = Color(0xFFE8F5E9); // lightest - backgrounds
  static const Color sage = Color(0xFFA5D6A7); // light accent - cards/chips
  static const Color leaf = Color(0xFF66BB6A); // primary - buttons/highlights
  static const Color forest = Color(0xFF1B5E20); // darkest - text/headers

  // Convenience aliases
  static const Color background = mint;
  static const Color primary = leaf;
  static const Color primaryDark = forest;
  static const Color surfaceAccent = sage;

  static const Color textPrimary = forest;
  static const Color textSecondary = Color(0xFF4E7C50); // muted forest tone
  static const Color white = Colors.white;
}
