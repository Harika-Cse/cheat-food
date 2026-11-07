import 'package:flutter/material.dart';

/// App color palette designed for "Cheat Food" - Indian Street Food Ordering.
/// Theme: Vibrant Indian street food vibe with deep saffron orange, chilli red,
/// appetizing warm cream surfaces, and bold slate/charcoal contrast.
class AppColors {
  // Primary Palette (Saffron & Chilli)
  static const Color primary = Color(0xFFFF5722);        // Vibrant Tandoor Orange
  static const Color primaryDark = Color(0xFFE64A19);    // Deep Saffron
  static const Color primaryLight = Color(0xFFFF8A65);   // Soft Paprika
  static const Color secondary = Color(0xFFD32F2F);      // Chilli Red
  static const Color secondaryLight = Color(0xFFFFCDD2); // Light Blush Red

  // Accent & Spices
  static const Color accent = Color(0xFFFFA000);         // Turmeric / Haldi Gold
  static const Color accentDark = Color(0xFFFF8F00);     // Warm Amber
  static const Color mintGreen = Color(0xFF2E7D32);      // Mint & Coriander Chutney
  static const Color tamarindBrown = Color(0xFF5D4037);  // Sweet Imli Chutney

  // Food Type Indicators
  static const Color veg = Color(0xFF2E7D32);            // Green dot for Pure Veg
  static const Color nonVeg = Color(0xFFC62828);         // Red dot for Non-Veg
  static const Color egg = Color(0xFFEF6C00);            // Orange dot for Egg-based

  // Warm Cream Backgrounds & Surfaces
  static const Color background = Color(0xFFFFFDF9);     // Warm Ivory Cream
  static const Color surface = Color(0xFFFFFFFF);        // Pure White
  static const Color surfaceWarm = Color(0xFFFFF7ED);    // Light Saffron Cream
  static const Color cardBg = Color(0xFFFFFFFF);         // Card Background
  static const Color chipBackground = Color(0xFFFFF1E6); // Category Chip Inactive

  // Dark Elements & Charcoal
  static const Color dark = Color(0xFF1A1D20);           // Deep Charcoal
  static const Color darkCard = Color(0xFF24282C);       // Dark Mode Card
  static const Color charcoalLight = Color(0xFF33383F);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2124);    // Rich Slate Black
  static const Color textSecondary = Color(0xFF6B7280);  // Neutral Slate Gray
  static const Color textLight = Color(0xFF9E9E9E);      // Light Hint Text
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // White on Orange/Red

  // Status & Utility
  static const Color success = Color(0xFF2E7D32);        // Order Delivered
  static const Color warning = Color(0xFFF57C00);        // Order Preparing
  static const Color info = Color(0xFF1976D2);           // Order Out for Delivery
  static const Color error = Color(0xFFD32F2F);          // Order Cancelled / Error
  static const Color divider = Color(0xFFEEEEEE);        // Crisp Divider
  static const Color shadow = Color(0x14000000);         // Soft Card Shadow (8% black)
  static const Color shadowWarm = Color(0x22FF5722);     // Warm Glow Shadow
}
